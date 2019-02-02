# spotify-example
sebastian@centricular.com
Hi Wayne,

Thanks for paying the invoice! Please find attached the Spotify/GStreamer code. As I told David before already, this is mostly a starting point that works but still has many lose ends, like the complete lack of error handling.

Depending on where you want to go with this, we could either get it production ready and implement missing features, error handling, etc.
or you could do that. David was planning to do that himself and only wanted such a prototype from us to get an idea of how it all can fit together.

So what you basically have there is a SpotifyPlayer class that wraps around libspotify and uses GStreamer for playback. And a small example application that uses it to list all tracks of a single playlist and play the first track. Playlists can be given by name, or by identifier as retrieved by the web API that David was using. From my understanding this was how he planned to use this.

Let me know if you (or Louis) have any questions about the code or anything else.


I saw the notes about libspotify, but there's not really any other alternative at this point for non-iOS/Android platforms and David also specifically wanted an implementation around libspotify. If Spotify ever comes up with a new SDK for non-iOS/Android platforms, we can certainly look into porting the code.


For A2DP, we worked with that protocol and also Bluez in the past. What exactly is it that you need here? We can certainly look into that but should get some contract in place between our two companies before that as we only had one with David before.


Best regards,
Sebastian

On Mo, 2016-06-06 at 11:37 -0400, Wayne Lederer wrote:
> Hi Sebastian,
>  
> David is no longer involved with this project, I have payed your 
> invoice. (please see attached) Can you please send me Val and Louis 
> the latest Spotify C++ code for our MagnaTouch project?
>  
> Did you see the recent notes on the Spotify site about that C++ code?
> Do you have any idea how will this affect operability going forward?
> (https://developer.spotify.com/news-stories/2016/03/22/recent-issues-
> libspotify/ )
>  
> I have contracted Louis Meadows (formally with the QT company) to 
> finish the Spotify build-in to our MagnaTouch Project.
>  
> Have you ever worked with A2DP to have Linux control a smart device 
> like this: the API is "BlueZ" http://www.bluez.org/  Support for BlueZ 
> 4.x and 5.x on Linux is in Qt 5.6 here is the document page htt 
> p://doc.qt.io/qt-5/qtbluetooth-index.html ? We would love to continue 
> to contract your help for a fee on this project going forward does 
> this work for you?
>  
> Thank you / Mit freundlichen Grüßen / Merci /Arigato / ありがとうございます / 
> Gracias / Afcharisto / Spaciba / Grazie / Shukriya / Obrigado / Tack / 
> Takk / Tak / Dziekuje / Спасибо / Bedankt / Toda / Vriendelijke 
> Groeten / Kiitos / Vielen Dank / Meilleures Salutations /Hvala /Terima 
> Kaseh / Koszonom / Xièxiè / Maholo / Teşekkürler / Shalom,
> 
> Wayne Lederer
> 516-239-0042 Office
> 516-672-2400 Cell
>  
> “Imagination is more important than knowledge. For knowledge is 
> limited to all we now know and understand, while imagination embraces 
> the entire world, and all there ever will be to know and understand.”
> Albert Einstein (1879-1955)
>  Privileged/Confidential Information may be contained in this message 
> and is intended solely for the use of the named addressee(s). Access 
> to this e-mail by anyone else is unauthorized. If you are not the 
> intended recipient, any disclosure, copying, distribution or re-use of 
> the information contained in it is prohibited and may be unlawful.
> Opinions, conclusions and any other information contained in this 
> message that do not relate to the official business of between the 
> receiver and Wayne Lederer shall be understood as neither given nor 
> endorsed by either party. If you have received this communication in 
> error, please notify Wayne Lederer immediately by replying to this 
> mail and deleting it from your computer ASAP.
>  
--
Sebastian Dröge, Centricular Ltd · http://www.centricular.com
