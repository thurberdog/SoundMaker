#ifndef __SPOTIFY_PLAYER_H__
#define __SPOTIFY_PLAYER_H__

#include <vector>
#include <set>
#include <map>
#include <memory>
#include <gst/gst.h>
#include <libspotify/api.h>

class SpotifyPlayer;
struct SpotifyPlaylist;
struct SpotifyPlaylistId;

struct SpotifyTrack {
  friend class SpotifyPlayer;
  friend struct SpotifyPlaylist;
public:
  const std::string& get_artist() const {
    return this->artist;
  }

  const std::string& get_name() const {
    return this->name;
  }

  int get_duration() const {
    return this->duration;
  }

  ~SpotifyTrack();

private:
  SpotifyTrack(std::shared_ptr<SpotifyPlaylistId>& playlist, sp_track *track);

  std::shared_ptr<SpotifyPlaylistId> playlist;
  sp_track *track;

  std::string artist, name;
  int duration;
};

struct SpotifyPlaylistId {
  friend class SpotifyPlayer;
  friend class SpotifyPlaylist;
public:
  const std::string& get_name() const {
    return this->name;
  }

  ~SpotifyPlaylistId();

private:
  SpotifyPlaylistId(sp_playlist *playlist);

  sp_playlist *playlist;
  std::string name;
};

struct SpotifyPlaylist {
  friend class SpotifyPlayer;
public:
  const std::string& get_name() const {
    return this->playlist->get_name();
  }

  const std::vector<std::shared_ptr<SpotifyTrack>>& get_tracks() const {
    return this->tracks;
  }

  ~SpotifyPlaylist();

private:
  SpotifyPlaylist(std::shared_ptr<SpotifyPlaylistId> playlist);

  std::shared_ptr<SpotifyPlaylistId> playlist;
  std::vector<std::shared_ptr<SpotifyTrack>> tracks;
};

class SpotifyPlayer {
public:
  typedef std::function<void()> ReadyCallback;
  typedef std::function<void(std::vector<std::shared_ptr<SpotifyPlaylistId>>& playlist_ids)> PlaylistListingCallback;
  typedef std::function<void(std::shared_ptr<SpotifyPlaylist>& playlist)> PlaylistFetchedCallback;

  SpotifyPlayer(const std::string& username, const std::string& password, ReadyCallback ready);
  ~SpotifyPlayer();

  void list_playlists(PlaylistListingCallback list_playlists);

  void fetch_playlist(const std::string& name, PlaylistFetchedCallback playlist_loaded);
  void fetch_playlist_by_id(const std::string& name, PlaylistFetchedCallback playlist_loaded);
  void fetch_playlist(std::shared_ptr<SpotifyPlaylistId> playlist_id, PlaylistFetchedCallback playlist_loaded);

  std::shared_ptr<GstElement> load_track(std::shared_ptr<SpotifyTrack>& track);
  void unload_track();
private:
  std::string username, password;
  ReadyCallback ready_callback;

  GMutex lock;
  sp_session *session;
  sp_playlistcontainer *playlist_container;
  std::set<sp_playlist*> subscribed_playlists;

  std::vector<PlaylistListingCallback> pending_playlist_listings;
  void check_pending_playlist_listings();

  std::vector<std::pair<std::shared_ptr<SpotifyPlaylistId>, std::function<void(std::shared_ptr<SpotifyPlaylist>)>>> pending_playlist_loads;
  void check_pending_playlist_loads();

  std::multimap<sp_playlist *, std::function<void(std::shared_ptr<SpotifyPlaylistId>)>> pending_raw_playlist_loads;
  void check_pending_raw_playlist_loads(sp_playlist *pl);

  void on_timeout();

  void logged_in(sp_error error);
  void notify_main_thread();
  int music_delivery(const sp_audioformat *format, const void *frames, int num_frames);
  void end_of_track();

  void playlist_added(sp_playlist *playlist);
  void playlist_removed(sp_playlist *playlist);
  void playlist_state_changed(sp_playlist *playlist);
  void container_loaded();
  void metadata_updated();

  void tracks_added(sp_playlist *playlist);

  std::set<guint> pending_sources;

  std::shared_ptr<SpotifyTrack> loaded_track;
  std::shared_ptr<GstElement> loaded_playbin, loaded_appsrc;
  gulong loaded_appsrc_query_probe_id;
  int loaded_appsrc_pending_seeks;
  bool loaded_appsrc_started;
  GstClockTime loaded_appsrc_base;
  guint64 loaded_appsrc_offset;

  void playbin_source_setup(GstElement *source, GstElement *playbin);
  void appsrc_enough_data(GstElement *source);
  void appsrc_need_data(guint size, GstElement *source);
  gboolean appsrc_seek_data(guint64 position, GstElement *source);

  GstPadProbeReturn appsrc_query_probe(GstPad *pad, GstPadProbeInfo *info);
};

#endif /* __SPOTIFY_PLAYER_H__ */
