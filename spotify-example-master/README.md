# spotify-example


Code where assertion failed

/**

 * @brief SpotifyPlayer::logged_in
 * 
 * @param error
 * 
 */

void SpotifyPlayer::logged_in(sp_error error) {

552===>  g_assert(error == SP_ERROR_OK);

  if (this->playlist_container)
  
    sp_playlistcontainer_release(this->playlist_container);

  this->playlist_container = sp_session_playlistcontainer(this->session);
  
  sp_playlistcontainer_add_callbacks(this->playlist_container, &pc_callbacks, this);
  
}




root@b2qt-colibri-imx6:/data/user# ./spotify2

Spotify api

**

ERROR:../spotify-example-master/spotify-player.cc:552:void SpotifyPlayer::logged_in(sp_error): assertion failed: (e)

Aborted

Change C key to magnatouch key 

sh-4.3# 

qt  spotify  spotify2  spotify3  tmp

sh-4.3# ./spotify3

Spotify api

**

ERROR:../spotify-example-master/spotify-player.cc:552:void SpotifyPlayer::logged_in(sp_error): assertion failed: (error == SP_ERROR_OK)

Aborted

Changed user name and passward

sh-4.3# 

sh-4.3# ./spotify4

Spotify api

Fetched: Rock 

num tracks: 100
	 - Ramble On (263000)
	 - Money - 2011 Remastered Version (383000)
	 - Life In The Fast Lane (286000)
	 - Rebel Rebel - 1999 Remastered Version (269000)
	 - Ace Of Spades (167000)
	 - Silver Machine - Original Single Version;Live At The Roundhouse London; 1996 Remastered Version (280000)
	 - Back In Black (255000)
	 - More Than a Feeling (285000)
	 - All Day and All of the Night (142000)
	 - Beast Of Burden - Remastered (265000)
	 - Should I Stay or Should I Go - Remastered (189000)
	 - Iron Man (355000)
	 - Won't Get Fooled Again - Original Album Version (511000)
	 - Paranoid (168000)
	 - Sultans Of Swing (350000)
	 - Ramblin' Man (288000)
	 - Sharp Dressed Man (2008 Remastered LP Version) (258000)
	 - Who Are You (379000)
	 - Barracuda (262000)
	 - Peace of Mind (304000)
	 - Long Cool Woman (In A Black Dress) - 1999 Remastered Version (199000)
	 - Can't You See (361000)
	 - We Will Rock You - Remastered 2011 (122000)
	 - (I Can't Get No) Satisfaction - Mono Version / Remastered 2002 (223000)
	 - Sweet Emotion (274000)
	 - House Of The Rising Sun (270000)
	 - Hey Joe (210000)
	 - China Grove (197000)
	 - For What It's Worth (154000)
	 - Sweet Child O' Mine (356000)
	 - Runnin' With The Devil (217000)
	 - Stranglehold (503000)
	 - Tom Sawyer (277000)
	 - All Along the Watchtower (241000)
	 - Good Times Bad Times (166000)
	 - My Generation (199000)
	 - Brown Sugar - Remastered (229000)
	 - White Room (303000)
	 - Heart Full of Soul (148000)
	 - Pinball Wizard (181000)
	 - Down On The Corner (166000)
	 - Brown Eyed Girl (183000)
	 - Dust in the Wind (206000)
	 - Honky Tonk Women (179000)
	 - Go Your Own Way (218000)
	 - You Really Got Me (134000)
	 - Radar Love (387000)
	 - Black Water (45 Version) (258000)
	 - Love Her Madly (198000)
	 - Gimme Three Steps (270000)
	 - Foreplay / Long Time (468000)
	 - The Chain (271000)
	 - Bad Company (Remastered Album Version) (287000)
	 - Fortunate Son (138000)
	 - American Woman - Remastered (307000)
	 - All Right Now (333000)
	 - Rocky Mountain Way (461000)
	 - Carry on Wayward Son (323000)
	 - Crazy On You (293000)
	 - Life's Been Good (536000)
	 - Another One Bites The Dust (215000)
	 - (Don't Fear) The Reaper (308000)
	 - The Joker (265000)
	 - La Grange - 2005 Remastered Version (230000)
	 - Walk This Way (211000)
	 - Strangers (200000)
	 - Nights In White Satin - Single Version (266000)
	 - Knockin' On Heaven's Door - Remastered (150000)
	 - Sunshine Of Your Love (250000)
	 - Welcome To The Jungle (272000)
	 - Piece of My Heart (253000)
	 - Have You Ever Seen The Rain? (160000)
	 - Born To Be Wild (210000)
	 - Cocaine (222000)
	 - Behind Blue Eyes - Original Album Version (223000)
	 - Break On Through (To The Other Side) (146000)
	 - Magic Carpet Ride (260000)
	 - Baba O'Riley - Original Album Version (300000)
	 - Layla - 40th Anniversary Version / 2010 Remastered (424000)
	 - Don't Stop Believin' (251000)
	 - Midnight Rider (180000)
	 - Bohemian Rhapsody - Remastered 2011 (354000)
	 - Paradise City (409000)
	 - Paint It Black (224000)
	 - Simple Man (358000)
	 - Suite: Judy Blue Eyes - Remastered (444000)
	 - Gimme Shelter (271000)
	 - Toys In The Attic (185000)
	 - Free Bird (559000)
	 - Sweet Home Alabama (281000)
	 - Bad Moon Rising (142000)
	 - Dream On (267000)
	 - Pour Some Sugar On Me (2012) (262000)
	 - Purple Haze (171000)
	 - Born to Run (270000)
	 - Let It Rain (302000)
	 - Mississippi Queen (151000)
	 - Walk on the Wild Side (254000)
	 - American Pie (517000)
	 - Listen To The Music (227000)
	 
playing  - Ramble On

(spotify4:534): GLib-GObject-WARNING **:

/home/dev/Qt/5.6/Boot2Qt/sources/meta-b2qt/build-colibri-imx6/tmp/work/armv7ahf-vfp-neon-poky-linux-gnueabi/glib-2.0/1_2.42.1-r0/glib-2.42.1/gobject/gsignal.c:3410: signal name 'push-sample' is invalid for instance '0x1af8188' of type 'GstAppSrc'
**

ERROR:../spotify-example-master/spotify-player.cc:882:int SpotifyPlayer::music_delivery(const sp_audioformat*, const void*, int): assertion failed: (ret == GST_FLOW_OK || ret == GST_FLOW_EOS || ret == GST_FLOW_FLUSHING)

Aborted
sh-4.3# 
Hi Lou,

this is also because you're using an old version of GStreamer. There
was no push-sample signal in your version yet, but also without it
there's the potential of getting errors at runtime under certain
circumstances (which hopefully don't happen here).

To get it working with the older GStreamer (ignoring the potential
problems), you would use the "push-buffer" signal and provide it the
GstBuffer instead of the GstSample. The caps would then be set via the
"caps" property on appsrc instead of storing them together with the
buffer in the sample. You need to ensure that the caps are set before
the buffer is passed to "push-sample".
Let me know if you want me to do that change.

Without this working it's normal that you don't get any sound and run
into this assertion.


Best regards,
Sebastian
sebastian@centricular.com
