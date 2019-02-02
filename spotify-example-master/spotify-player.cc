#include "spotify-player.h"
#include <iostream>
#include <libspotify/api.h>
#include <sstream>
#include <gst/gst.h>
#include <gst/gstpad.h>
#include <gst/audio/audio.h>
#include "appkey.c"

// TODO: Handle dynamic track changes
// TODO: Handle more metadata
/**
 * @brief SpotifyTrack::SpotifyTrack
 * @param playlist
 * @param track
 */
SpotifyTrack::SpotifyTrack(std::shared_ptr<SpotifyPlaylistId>& playlist, sp_track *track) :
    playlist(playlist),
    track(track) {
  g_assert(sp_track_is_loaded(track));

  sp_track_add_ref(track);

  auto n = sp_track_num_artists(track);

  if (n > 0) {
// It doesn't compile, as I am getting this error:

//  error: use of deleted function ‘std::basic_stringstream<char>& std::basic_stringst
//  The errors are related to std::stringstream type.
//  Try to use simple std::string instead of std::stringstream.
//  At least I was able to avoid this error when using std::string
//   std::string artist_builder;
//std::stringstream is not copyable.
//  To copy the content you can just write the content of one stream to another:
  std::stringstream artist_build;
  auto artist_builder = artist_build.str();

    for (auto i = 0; i < n; i++) {
      auto artist = sp_track_artist(track, i);
      g_assert(sp_artist_is_loaded(artist));

      auto artist_name = sp_artist_name(artist);
      if (!artist_name || *artist_name == '\0')
        continue;

      if (artist_builder.length())
        artist_build << ", " << artist_name;
      else
        artist_build << artist_name;
    }
    this->artist = artist_builder;
  } else {
    this->artist = "Unknown Artist";
  }
  this->name = sp_track_name(track);
  this->duration = sp_track_duration(track);
}

/**
 * @brief SpotifyTrack::~SpotifyTrack
 */
SpotifyTrack::~SpotifyTrack() {
  sp_track_release(this->track);
  this->track = nullptr;
}

/**
 * @brief SpotifyPlaylistId::SpotifyPlaylistId
 * @param playlist
 */
SpotifyPlaylistId::SpotifyPlaylistId(sp_playlist *playlist) :
    playlist(playlist),
    name() {
  g_assert(sp_playlist_is_loaded(playlist));
  sp_playlist_add_ref(playlist);

  auto name_cstr = sp_playlist_name(playlist);
  g_assert(name_cstr != nullptr);
  name = name_cstr;
}

/**
 * @brief SpotifyPlaylistId::~SpotifyPlaylistId
 */
SpotifyPlaylistId::~SpotifyPlaylistId() {
  sp_playlist_release(this->playlist);
  this->playlist = nullptr;
}


// TODO: Handle dynamic playlist changes
/**
 * @brief SpotifyPlaylist::SpotifyPlaylist
 * @param playlist
 */
SpotifyPlaylist::SpotifyPlaylist(std::shared_ptr<SpotifyPlaylistId> playlist) :
    playlist(playlist),
    tracks() {
  for (auto i = 0; i < sp_playlist_num_tracks(playlist->playlist); i++) {
    auto t = sp_playlist_track(playlist->playlist, i);
    tracks.push_back(std::make_shared<SpotifyTrack>(SpotifyTrack(playlist, t)));
  }
}

/**
 * @brief SpotifyPlaylist::~SpotifyPlaylist
 */
SpotifyPlaylist::~SpotifyPlaylist() {
}

// TODO: Error handling!

static bool callbacks_initialized = false;
static sp_session_callbacks session_callbacks = { /* filled in run function */ };
static sp_playlistcontainer_callbacks pc_callbacks = { /* filled in run function */ };
static sp_playlist_callbacks pl_callbacks = { /* filled in run function */ };

static sp_session_config spconfig = {
    .api_version = SPOTIFY_API_VERSION,
    .cache_location = "tmp",
    .settings_location = "tmp",
    .application_key = g_appkey,
    .application_key_size = sizeof(g_appkey),
    .user_agent = "spotify-example",
    .callbacks = &session_callbacks,
    nullptr,
};

/**
 * @brief SpotifyPlayer::SpotifyPlayer
 * @param username
 * @param password
 * @param ready
 */
SpotifyPlayer::SpotifyPlayer(const std::string& username, const std::string& password, ReadyCallback ready) :
    username(username),
    password(password),
    ready_callback(ready),
    session(nullptr),
    playlist_container(nullptr),
    subscribed_playlists(),
    pending_playlist_listings(),
    pending_playlist_loads(),
    pending_raw_playlist_loads(),
    pending_sources(),
    loaded_track(),
    loaded_playbin(),
    loaded_appsrc(),
    loaded_appsrc_query_probe_id(0),
    loaded_appsrc_pending_seeks(0),
    loaded_appsrc_started(false),
    loaded_appsrc_base(0),
    loaded_appsrc_offset(0) {
  g_mutex_init(&this->lock);
  if (!callbacks_initialized) {
    // TODO: Handle the various other dynamic callbacks, especially
    // error reporting!
    session_callbacks.logged_in = [] (sp_session *session, sp_error error) {
      auto self = static_cast<SpotifyPlayer*>(sp_session_userdata(session));
      self->logged_in(error);
    };
    session_callbacks.notify_main_thread = [] (sp_session *session) {
      auto self = static_cast<SpotifyPlayer*>(sp_session_userdata(session));
      self->notify_main_thread();
    };
    session_callbacks.music_delivery = [] (sp_session *session, const sp_audioformat *format,
                          const void *frames, int num_frames) -> int {
      auto self = static_cast<SpotifyPlayer*>(sp_session_userdata(session));
      return self->music_delivery(format, frames, num_frames);
    };
    session_callbacks.end_of_track = [] (sp_session *session) {
      auto self = static_cast<SpotifyPlayer*>(sp_session_userdata(session));
      return self->end_of_track();
    };
    session_callbacks.metadata_updated = [] (sp_session *session) {
      auto self = static_cast<SpotifyPlayer*>(sp_session_userdata(session));
      self->metadata_updated();
    };

    // TODO: Handle playlist_moved / playlist_removed
    pc_callbacks.playlist_added = [] (sp_playlistcontainer *pc, sp_playlist *playlist, int position, void *user_data) {
      auto self = static_cast<SpotifyPlayer*>(user_data);
      self->playlist_added(playlist);
    };
    pc_callbacks.playlist_removed = [] (sp_playlistcontainer *pc, sp_playlist *playlist, int position, void *user_data) {
      auto self = static_cast<SpotifyPlayer*>(user_data);
      self->playlist_removed(playlist);
    };
    pc_callbacks.container_loaded = [] (sp_playlistcontainer *pc, void *user_data) {
      auto self = static_cast<SpotifyPlayer*>(user_data);
      self->container_loaded();
    };

    // TODO: Handle dynamic playlist changes
    pl_callbacks.tracks_added = [] (sp_playlist *pl, sp_track * const *tracks, int num_tracks, int position, void *user_data) {
      auto self = static_cast<SpotifyPlayer*>(user_data);
      self->tracks_added(pl);
    };
    pl_callbacks.playlist_state_changed = [] (sp_playlist *playlist, void *user_data) {
      auto self = static_cast<SpotifyPlayer*>(user_data);
      self->playlist_state_changed(playlist);
    };

    callbacks_initialized = true;
  }

  spconfig.userdata = this;
  sp_error err = sp_session_create(&spconfig, &this->session);
  g_assert(err == SP_ERROR_OK);

  sp_session_login(this->session, this->username.c_str(), this->password.c_str(), 0, nullptr);

  this->notify_main_thread();
}

SpotifyPlayer::~SpotifyPlayer() {
  for (auto pl: this->subscribed_playlists) {
    sp_playlist_remove_callbacks(pl, &pl_callbacks, this);
    sp_playlist_release(pl);
  }
  if (this->playlist_container) {
    sp_playlistcontainer_remove_callbacks(this->playlist_container, &pc_callbacks, this);
    sp_playlistcontainer_release(this->playlist_container);
    this->playlist_container = nullptr;
  }

  for (auto it: this->pending_raw_playlist_loads) {
    sp_playlist_release(it.first);
  }
  this->pending_raw_playlist_loads.clear();

  sp_session_logout(this->session);
  sp_session_release(this->session);
  this->session = nullptr;

  g_mutex_lock(&this->lock);
  for (auto source: this->pending_sources) {
    g_source_remove(source);
  }
  g_mutex_unlock(&this->lock);
  g_mutex_clear(&this->lock);
}

/**
 * @brief SpotifyPlayer::list_playlists
 * @param list_playlists
 */
void SpotifyPlayer::list_playlists(PlaylistListingCallback list_playlists) {
  this->pending_playlist_listings.push_back(list_playlists);

  struct ListPlaylistsData {
    SpotifyPlayer *self;
    guint id;
  };

  g_mutex_lock(&this->lock);
  auto data = new ListPlaylistsData {this, 0};
  data->id = g_idle_add_full(G_PRIORITY_DEFAULT, [] (gpointer user_data) -> gboolean {
    auto data = static_cast<ListPlaylistsData*>(user_data);
    data->self->check_pending_playlist_listings();

    g_mutex_lock(&data->self->lock);
    auto count = data->self->pending_sources.erase(data->id);
    g_assert(count == 1);
    g_mutex_unlock(&data->self->lock);

    return G_SOURCE_REMOVE;
  }, data, [] (gpointer user_data) {
    delete static_cast<ListPlaylistsData*>(user_data);
  });
  this->pending_sources.insert(data->id);
  g_mutex_unlock(&this->lock);
}

/**
 * @brief SpotifyPlayer::check_pending_playlist_listings
 */
void SpotifyPlayer::check_pending_playlist_listings() {
  if (this->pending_playlist_listings.empty())
    return;
  if (!sp_playlistcontainer_is_loaded(this->playlist_container))
    return;

  auto unnamed_playlists = false;
  std::vector<std::shared_ptr<SpotifyPlaylistId>> playlists;

  auto n = sp_playlistcontainer_num_playlists(this->playlist_container);
  for (auto i = 0; i < n; i++) {
    auto pl = sp_playlistcontainer_playlist(this->playlist_container, i);

    if (this->subscribed_playlists.find(pl) == this->subscribed_playlists.end()) {
      sp_playlist_add_callbacks(pl, &pl_callbacks, this);
      sp_playlist_add_ref(pl);
      this->subscribed_playlists.insert(pl);
    }

    if (std::string(sp_playlist_name(pl)).empty() || !sp_playlist_is_loaded(pl)) {
      unnamed_playlists = true;
      break;
    }

    playlists.push_back(std::make_shared<SpotifyPlaylistId>(SpotifyPlaylistId(pl)));
  }

  if (!unnamed_playlists) {
    for (auto callback : this->pending_playlist_listings) {
      callback(playlists);
    }
    this->pending_playlist_listings.clear();
  }
}

/**
 * @brief SpotifyPlayer::fetch_playlist
 * @param playlist_id
 * @param playlist_loaded
 */
void SpotifyPlayer::fetch_playlist(std::shared_ptr<SpotifyPlaylistId> playlist_id, PlaylistFetchedCallback playlist_loaded) {
  g_assert(playlist_id != false);
  g_assert(sp_playlistcontainer_is_loaded(this->playlist_container));

  this->pending_playlist_loads.push_back(std::make_pair(playlist_id, [=] (std::shared_ptr<SpotifyPlaylist> pl) {
    playlist_loaded(pl);
  }));

  struct FetchPlaylistData {
    SpotifyPlayer *self;
    guint id;
  };

  g_mutex_lock(&this->lock);
  auto data = new FetchPlaylistData {this, 0};
  data->id = g_idle_add_full(G_PRIORITY_DEFAULT, [] (gpointer user_data) -> gboolean {
    auto data = static_cast<FetchPlaylistData*>(user_data);
    data->self->check_pending_playlist_loads();

    g_mutex_lock(&data->self->lock);
    auto count = data->self->pending_sources.erase(data->id);
    g_assert(count == 1);
    g_mutex_unlock(&data->self->lock);

    return G_SOURCE_REMOVE;
  }, data, [] (gpointer user_data) {
    delete static_cast<FetchPlaylistData*>(user_data);
  });
  this->pending_sources.insert(data->id);
  g_mutex_unlock(&this->lock);
}

/**
 * @brief SpotifyPlayer::fetch_playlist
 * @param name
 * @param playlist_loaded
 */
void SpotifyPlayer::fetch_playlist(const std::string& name, PlaylistFetchedCallback playlist_loaded) {
  this->list_playlists([playlist_loaded, name, this] (std::vector<std::shared_ptr<SpotifyPlaylistId>>& playlists) {
    for (auto playlist_id: playlists) {
      if (playlist_id->get_name() == name) {
        this->fetch_playlist(playlist_id, playlist_loaded);
        return;
      }
    }

    std::shared_ptr<SpotifyPlaylist> playlist;
    playlist_loaded(playlist);
  });
}

/**
 * @brief SpotifyPlayer::fetch_playlist_by_id
 * @param name
 * @param playlist_loaded
 */
void SpotifyPlayer::fetch_playlist_by_id(const std::string& name, PlaylistFetchedCallback playlist_loaded) {
  // TODO: Might want to make the user configurable
  auto link = sp_link_create_from_string(("spotify:user:spotify:playlist:" + name).c_str());
  auto pl = sp_playlist_create(this->session, link);

  if (this->subscribed_playlists.find(pl) == this->subscribed_playlists.end()) {
    sp_playlist_add_callbacks(pl, &pl_callbacks, this);
    sp_playlist_add_ref(pl);
    this->subscribed_playlists.insert(pl);
  }

  sp_playlist_set_in_ram(this->session, pl, true);

  // pl owned by the map
  // FIXME: We will leak this forever if the playlist never gets loaded
  this->pending_raw_playlist_loads.insert(std::make_pair(pl, [playlist_loaded, this] (std::shared_ptr<SpotifyPlaylistId> pl) {
    this->fetch_playlist(pl, playlist_loaded);
  }));

  struct FetchPlaylistByIdData {
    SpotifyPlayer *self;
    sp_playlist *pl; // not owned by us
    guint id;
  };

  g_mutex_lock(&this->lock);
  auto data = new FetchPlaylistByIdData {this, pl, 0};
  data->id = g_idle_add_full(G_PRIORITY_DEFAULT, [] (gpointer user_data) -> gboolean {
    auto data = static_cast<FetchPlaylistByIdData*>(user_data);

    data->self->check_pending_raw_playlist_loads(data->pl);

    g_mutex_lock(&data->self->lock);
    auto count = data->self->pending_sources.erase(data->id);
    g_assert(count == 1);
    g_mutex_unlock(&data->self->lock);

    return G_SOURCE_REMOVE;
  }, data, [] (gpointer user_data) {
    delete static_cast<FetchPlaylistByIdData*>(user_data);
  });
  this->pending_sources.insert(data->id);
  g_mutex_unlock(&this->lock);
}

/**
 * @brief SpotifyPlayer::check_pending_raw_playlist_loads
 * @param pl
 */
void SpotifyPlayer::check_pending_raw_playlist_loads(sp_playlist *pl) {
  auto it_range = this->pending_raw_playlist_loads.equal_range(pl);
  if (it_range.first != it_range.second) {
    if (sp_playlist_is_loaded(pl)) {
      auto id = std::make_shared<SpotifyPlaylistId>(SpotifyPlaylistId(pl));

      for (auto it = it_range.first; it != it_range.second; ++it) {
        it->second(id);
      }
      this->pending_raw_playlist_loads.erase(it_range.first, it_range.second);
      sp_playlist_release(pl);
    }
  }
}

/**
 * @brief SpotifyPlayer::check_pending_playlist_loads
 */
void SpotifyPlayer::check_pending_playlist_loads() {
  if (this->pending_playlist_loads.empty())
    return;

  for (auto it = this->pending_playlist_loads.begin(); it != this->pending_playlist_loads.end(); /* below */) {
    auto pending_load = *it;
    auto playlist = pending_load.first->playlist;
    if (!sp_playlist_is_loaded(playlist)) {
      ++it;
      continue;
    }

    auto n = sp_playlist_num_tracks(playlist);
    if (n == 0) {
      std::shared_ptr<SpotifyPlaylist> playlist;
      pending_load.second(playlist);
      it = this->pending_playlist_loads.erase(it);
      continue;
    }

    auto pending_tracks = false;
    for (auto i = 0; i < n; i++) {
      auto track = sp_playlist_track(playlist, i);
      pending_tracks = pending_tracks || !sp_track_is_loaded(track);
      if (pending_tracks)
        break;
    }

    if (pending_tracks) {
      ++it;
      continue;
    }

    pending_load.second(std::make_shared<SpotifyPlaylist>(SpotifyPlaylist(pending_load.first)));
    it = this->pending_playlist_loads.erase(it);
  }
}

/**
 * @brief SpotifyPlayer::playlist_added
 * @param playlist
 */
void SpotifyPlayer::playlist_added(sp_playlist *playlist) {
  this->check_pending_playlist_listings();
  this->check_pending_playlist_loads();
  this->check_pending_raw_playlist_loads(playlist);
}

/**
 * @brief SpotifyPlayer::playlist_removed
 * @param playlist
 */
void SpotifyPlayer::playlist_removed(sp_playlist *playlist) {
  this->check_pending_playlist_listings();
  this->check_pending_playlist_loads();
  this->check_pending_raw_playlist_loads(playlist);

  this->pending_raw_playlist_loads.erase(playlist);
  auto count = this->subscribed_playlists.erase(playlist);
  if (count) {
    g_assert(count == 1);
    sp_playlist_remove_callbacks(playlist, &pl_callbacks, this);
    sp_playlist_release(playlist);
  }
}

/**
 * @brief SpotifyPlayer::tracks_added
 * @param playlist
 */
void SpotifyPlayer::tracks_added(sp_playlist *playlist) {
  this->check_pending_playlist_loads();
  this->check_pending_raw_playlist_loads(playlist);
}

/**
 * @brief SpotifyPlayer::playlist_state_changed
 * @param playlist
 */
void SpotifyPlayer::playlist_state_changed(sp_playlist *playlist) {
  this->check_pending_playlist_listings();
  this->check_pending_playlist_loads();
  this->check_pending_raw_playlist_loads(playlist);
}

/**
 * @brief SpotifyPlayer::container_loaded
 */
void SpotifyPlayer::container_loaded() {
  if (this->ready_callback)
    this->ready_callback();
  this->ready_callback = nullptr;

  this->check_pending_playlist_listings();
  this->check_pending_playlist_loads();
}

/**
 * @brief SpotifyPlayer::metadata_updated
 */
void SpotifyPlayer::metadata_updated() {
  this->check_pending_playlist_listings();
  this->check_pending_playlist_loads();
}

/**
 * @brief SpotifyPlayer::logged_in
 * @param error
 */
void SpotifyPlayer::logged_in(sp_error error) {
  g_assert(error == SP_ERROR_OK);

  if (this->playlist_container)
    sp_playlistcontainer_release(this->playlist_container);

  this->playlist_container = sp_session_playlistcontainer(this->session);
  sp_playlistcontainer_add_callbacks(this->playlist_container, &pc_callbacks, this);
}

/**
 * @brief SpotifyPlayer::on_timeout
 */
void SpotifyPlayer::on_timeout() {
  auto err = SP_ERROR_OK;
  auto next_timeout = 0;

  do {
    err = sp_session_process_events(this->session, &next_timeout);
  } while (next_timeout <= 0 && err == SP_ERROR_OK);

  g_assert(err == SP_ERROR_OK);

  struct TimeoutData {
    SpotifyPlayer *self;
    guint id;
  };

  g_mutex_lock(&this->lock);
  auto data = new TimeoutData {this, 0};
  data->id = g_timeout_add_full(G_PRIORITY_DEFAULT, next_timeout, [] (gpointer user_data) -> gboolean {
    auto data = static_cast<TimeoutData*>(user_data);
    data->self->on_timeout();

    g_mutex_lock(&data->self->lock);
    auto count = data->self->pending_sources.erase(data->id);
    g_assert(count == 1);
    g_mutex_unlock(&data->self->lock);

    return G_SOURCE_REMOVE;
  }, data, [] (gpointer user_data) {
    delete static_cast<TimeoutData*>(user_data);
  });
  this->pending_sources.insert(data->id);
  g_mutex_unlock(&this->lock);
}

/**
 * @brief SpotifyPlayer::notify_main_thread
 */
void SpotifyPlayer::notify_main_thread() {
  struct NotifyMainThreadData {
    SpotifyPlayer *self;
    guint id;
  };

  g_mutex_lock(&this->lock);
  auto data = new NotifyMainThreadData {this, 0};
  data->id = g_idle_add_full(G_PRIORITY_DEFAULT, [] (gpointer user_data) -> gboolean {
    auto data = static_cast<NotifyMainThreadData*>(user_data);
    data->self->on_timeout();

    g_mutex_lock(&data->self->lock);
    auto count = data->self->pending_sources.erase(data->id);
    g_assert(count == 1);
    g_mutex_unlock(&data->self->lock);

    return G_SOURCE_REMOVE;
  }, data, [] (gpointer user_data) {
    delete static_cast<NotifyMainThreadData*>(user_data);
  });
  this->pending_sources.insert(data->id);
  g_mutex_unlock(&this->lock);
}

std::shared_ptr<GstElement> SpotifyPlayer::load_track(std::shared_ptr<SpotifyTrack>& track) {
  std::shared_ptr<GstElement> playbin = std::shared_ptr<GstElement>(gst_element_factory_make("playbin", NULL), [] (GstElement *e) { gst_object_unref(GST_ELEMENT(e));} );

  this->loaded_playbin = playbin;
  this->loaded_track = track;
  g_object_set(playbin.get(), "uri", "appsrc:", nullptr);
  g_signal_connect_swapped(playbin.get(), "source-setup", G_CALLBACK(&SpotifyPlayer::playbin_source_setup), this);

  sp_session_player_load(this->session, track->track);

  return playbin;
}

/**
 * @brief SpotifyPlayer::playbin_source_setup
 * @param source
 * @param playbin
 */
void SpotifyPlayer::playbin_source_setup(GstElement *source, GstElement *playbin) {
  if (playbin != this->loaded_playbin.get())
    return;

  this->loaded_appsrc = std::shared_ptr<GstElement>(GST_ELEMENT(gst_object_ref(source)), [] (GstElement *e) { gst_object_unref(GST_ELEMENT(e));} );
  this->loaded_appsrc_pending_seeks = 0;
  this->loaded_appsrc_started = false;
  this->loaded_appsrc_base = 0;
  this->loaded_appsrc_offset = 0;

  g_object_set(source,
    "emit-signals", TRUE,
    "format", GST_FORMAT_TIME,
    "max-bytes", static_cast<guint64>(1 * 1024 * 1024),
    "min-percent", 10,
    "stream-type", 1 /* SEEKABLE */,
    nullptr);

  auto srcpad = std::shared_ptr<GstPad>(gst_element_get_static_pad(source, "src"), [] (GstPad *p) { gst_object_unref(GST_PAD(p));});
  this->loaded_appsrc_query_probe_id = gst_pad_add_probe(srcpad.get(), GST_PAD_PROBE_TYPE_QUERY_UPSTREAM, [] (GstPad *pad, GstPadProbeInfo *info, gpointer user_data) {
    return static_cast<SpotifyPlayer*>(user_data)->appsrc_query_probe(pad, info);
  }, this, nullptr);

  g_signal_connect_swapped(source, "enough-data", G_CALLBACK(&SpotifyPlayer::appsrc_enough_data), this);
  g_signal_connect_swapped(source, "need-data", G_CALLBACK(&SpotifyPlayer::appsrc_need_data), this);
  g_signal_connect_swapped(source, "seek-data", G_CALLBACK(&SpotifyPlayer::appsrc_seek_data), this);
}

/**
 * @brief SpotifyPlayer::appsrc_enough_data
 * @param source
 */
void SpotifyPlayer::appsrc_enough_data(GstElement *source) {
  if (source != this->loaded_appsrc.get())
    return;

  struct AppSrcEnoughDataData {
    SpotifyPlayer *self;
    guint id;
  };

  g_mutex_lock(&this->lock);
  auto data = new AppSrcEnoughDataData {this, 0};
  data->id = g_idle_add_full(G_PRIORITY_DEFAULT, [] (gpointer user_data) -> gboolean {
    auto data = static_cast<AppSrcEnoughDataData*>(user_data);
    sp_session_player_play(data->self->session, 0);

    g_mutex_lock(&data->self->lock);
    auto count = data->self->pending_sources.erase(data->id);
    g_assert(count == 1);
    g_mutex_unlock(&data->self->lock);

    return G_SOURCE_REMOVE;
  }, data, [] (gpointer user_data) {
    delete static_cast<AppSrcEnoughDataData*>(user_data);
  });
  this->pending_sources.insert(data->id);
  g_mutex_unlock(&this->lock);
}

/**
 * @brief SpotifyPlayer::appsrc_need_data
 * @param size
 * @param source
 */
void SpotifyPlayer::appsrc_need_data(guint size, GstElement *source) {
  if (source != this->loaded_appsrc.get())
    return;

  struct AppSrcNeedDataData {
    SpotifyPlayer *self;
    guint id;
  };

  g_mutex_lock(&this->lock);
  this->loaded_appsrc_started = true;
  auto data = new AppSrcNeedDataData {this, 0};
  data->id = g_idle_add_full(G_PRIORITY_DEFAULT, [] (gpointer user_data) -> gboolean {
    auto data = static_cast<AppSrcNeedDataData*>(user_data);
    sp_session_player_play(data->self->session, 1);

    g_mutex_lock(&data->self->lock);
    auto count = data->self->pending_sources.erase(data->id);
    g_assert(count == 1);
    g_mutex_unlock(&data->self->lock);

    return G_SOURCE_REMOVE;
  }, data, [] (gpointer user_data) {
    delete static_cast<AppSrcNeedDataData*>(user_data);
  });
  this->pending_sources.insert(data->id);
  g_mutex_unlock(&this->lock);
}

/**
 * @brief SpotifyPlayer::appsrc_seek_data
 * @param position
 * @param source
 * @return
 */
gboolean SpotifyPlayer::appsrc_seek_data(guint64 position, GstElement *source) {
  if (source != this->loaded_appsrc.get())
    return FALSE;

  struct AppSrcSeekDataData {
    SpotifyPlayer *self;
    guint id;
    guint64 position;
  };

  g_mutex_lock(&this->lock);
  this->loaded_appsrc_base = position;
  this->loaded_appsrc_offset = 0;
  if (this->loaded_appsrc_started)
    this->loaded_appsrc_pending_seeks++;
  auto data = new AppSrcSeekDataData {this, 0, position};
  data->id = g_idle_add_full(G_PRIORITY_DEFAULT, [] (gpointer user_data) -> gboolean {
    auto data = static_cast<AppSrcSeekDataData*>(user_data);
    sp_session_player_seek(data->self->session, data->position / GST_MSECOND);

    g_mutex_lock(&data->self->lock);
    auto count = data->self->pending_sources.erase(data->id);
    g_assert(count == 1);
    g_mutex_unlock(&data->self->lock);

    return G_SOURCE_REMOVE;
  }, data, [] (gpointer user_data) {
    delete static_cast<AppSrcSeekDataData*>(user_data);
  });
  this->pending_sources.insert(data->id);
  g_mutex_unlock(&this->lock);

  return TRUE;
}

/**
 * @brief SpotifyPlayer::appsrc_query_probe
 * @param pad
 * @param info
 * @return
 */
GstPadProbeReturn SpotifyPlayer::appsrc_query_probe(GstPad *pad, GstPadProbeInfo *info) {
  if (GST_OBJECT_PARENT(pad) != GST_OBJECT(this->loaded_appsrc.get()))
    return GST_PAD_PROBE_OK;

  auto query = GST_QUERY(info->data);

  if (GST_QUERY_TYPE(query) != GST_QUERY_DURATION)
    return GST_PAD_PROBE_OK;

  GstFormat format;
  gst_query_parse_duration(query, &format, NULL);
  if (format != GST_FORMAT_TIME)
    return GST_PAD_PROBE_OK;

  gst_query_set_duration(query, GST_FORMAT_TIME, GST_MSECOND * static_cast<guint64>(this->loaded_track->get_duration()));
// error: 'GST_PAD_PROBE_HANDLED' was not declared in this scope
  return GST_PAD_PROBE_HANDLED;
//TODO
//TODO *** need to unref the buffer or event
//TODO
//  return GST_PAD_PROBE_DROP;
  // Data has been handled in the probe and will not be forwarded further.
  // For events and buffers this is the same behaviour as GST_PAD_PROBE_DROP
  // (except that in this case you need to unref the buffer or event yourself).
  // For queries it will also return TRUE to the caller.
  // The probe can also modify the GstFlowReturn value by using the
  // GST_PAD_PROBE_INFO_FLOW_RETURN() accessor.
  // Note that the resulting query must contain valid entries. Since: 1.6

}

/**
 * @brief SpotifyPlayer::unload_track
 */
void SpotifyPlayer::unload_track() {
  if (this->loaded_appsrc) {
    g_signal_handlers_disconnect_by_data(this->loaded_appsrc.get(), this);
    auto srcpad = std::shared_ptr<GstPad>(gst_element_get_static_pad(this->loaded_appsrc.get(), "src"), [] (GstPad *p) { gst_object_unref(GST_PAD(p));});
    gst_pad_remove_probe(srcpad.get(), this->loaded_appsrc_query_probe_id);
  }
  this->loaded_appsrc = nullptr;

  if (this->loaded_playbin) {
    gst_element_set_state(this->loaded_playbin.get(), GST_STATE_NULL);
    g_signal_handlers_disconnect_by_data(this->loaded_playbin.get(), this);
  }
  this->loaded_playbin = nullptr;

  this->loaded_appsrc_query_probe_id = 0;
  this->loaded_appsrc_pending_seeks = 0;
  this->loaded_appsrc_started = false;
  this->loaded_appsrc_base = 0;
  this->loaded_appsrc_offset = 0;

  if (this->loaded_track)
    sp_session_player_unload(this->session);
  this->loaded_track = nullptr;
}

/**
 * @brief SpotifyPlayer::music_delivery
 * @param format
 * @param frames
 * @param num_frames
 * @return
 */
int SpotifyPlayer::music_delivery(const sp_audioformat *format, const void *frames, int num_frames) {
  if (!this->loaded_appsrc)
    return num_frames;

  g_mutex_lock(&this->lock);
  if (num_frames <= 0) {
    this->loaded_appsrc_pending_seeks--;
    if (this->loaded_appsrc_pending_seeks < 0)
      this->loaded_appsrc_pending_seeks = 0;
    g_mutex_unlock(&this->lock);
    return 0;
  }

  if (this->loaded_appsrc_pending_seeks == 0) {
    GstAudioInfo info;
    gst_audio_info_set_format(&info, GST_AUDIO_FORMAT_S16, format->sample_rate, format->channels, nullptr);
    auto caps = gst_audio_info_to_caps(&info);

    auto buffer = gst_buffer_new_allocate(nullptr, num_frames * 2 * format->channels, nullptr);
    gst_buffer_fill(buffer, 0, frames, num_frames * 2 * format->channels);

    GST_BUFFER_PTS(buffer) = this->loaded_appsrc_base + gst_util_uint64_scale(this->loaded_appsrc_offset, GST_SECOND, format->sample_rate);
    auto sample = gst_sample_new(buffer, caps, nullptr, nullptr);
    GstFlowReturn ret;
    g_signal_emit_by_name(this->loaded_appsrc.get(), "push-sample", sample, &ret);
    gst_buffer_unref(buffer);
    gst_caps_unref(caps);
    gst_sample_unref(sample);
    g_assert(ret == GST_FLOW_OK || ret == GST_FLOW_EOS || ret == GST_FLOW_FLUSHING);
    this->loaded_appsrc_offset += num_frames;
  }
  g_mutex_unlock(&this->lock);

  return num_frames;
}

/**
 * @brief SpotifyPlayer::end_of_track
 */
void SpotifyPlayer::end_of_track() {
  GstFlowReturn ret;
  g_signal_emit_by_name(this->loaded_appsrc.get(), "end-of-stream", &ret);
}

