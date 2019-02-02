#include <QCoreApplication>

#include "spotify-player.h"

int
main(int argc, char **argv)
{
  gst_init(&argc, &argv);
  QCoreApplication app(argc, argv);

  SpotifyPlayer player = SpotifyPlayer("magnatouch", "MriMusic", [&] () {
    player.list_playlists([&] (std::vector<std::shared_ptr<SpotifyPlaylistId>>& playlists) {
      for (auto playlist: playlists)
        g_print("Found playlist: %s\n", playlist->get_name().c_str());
    });
    //player.fetch_playlist("Feel Good Indie Rock", [&] (std::shared_ptr<SpotifyPlaylist> playlist) {
    player.fetch_playlist_by_id("2Qi8yAzfj1KavAhWz1gaem", [&] (std::shared_ptr<SpotifyPlaylist> playlist) {
      g_print("Fetched: %s\n", playlist->get_name().c_str());

      auto tracks = playlist->get_tracks();
      g_print("num tracks: %d\n", (int) tracks.size());
      for (auto track: tracks)
        g_print("\t%s - %s (%d)\n", track->get_artist().c_str(), track->get_name().c_str(), track->get_duration());

      if (tracks.size() > 0) {
        auto track = tracks.front();
        g_print("playing %s - %s\n", track->get_artist().c_str(), track->get_name().c_str());
        auto pipeline = player.load_track(track);

        g_assert(gst_element_set_state(pipeline.get(), GST_STATE_PLAYING) != GST_STATE_CHANGE_FAILURE);

        g_timeout_add_seconds(5, [] (gpointer user_data) -> gboolean {
          g_print("seeking\n");
          g_assert(gst_element_seek_simple(GST_ELEMENT(user_data), GST_FORMAT_TIME, GST_SEEK_FLAG_FLUSH, 30 * GST_SECOND));
          return G_SOURCE_REMOVE;
        }, pipeline.get());

        g_timeout_add_seconds(1, [] (gpointer user_data) -> gboolean {
          gint64 position = -1, duration = -1;
          gst_element_query_position(GST_ELEMENT(user_data), GST_FORMAT_TIME, &position);
          gst_element_query_duration(GST_ELEMENT(user_data), GST_FORMAT_TIME, &duration);
          g_print("position %" GST_TIME_FORMAT " / %" GST_TIME_FORMAT "\n", GST_TIME_ARGS(position), GST_TIME_ARGS(duration));
          return G_SOURCE_CONTINUE;
        }, pipeline.get());
      }
    });
  });

  return app.exec();
}
