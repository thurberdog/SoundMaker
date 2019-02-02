libspotify 12.1.51 API Documentation

This documentation explains how you can make use of the libspotify C API within an application of your own.

The documentation was generated with Doxygen. You will find a list of submodules in the Modules section. The list of modules are ordered in a reasonable reading order. It begins with some simple types used throughout the rest of the modules, continues with basic error handling and the functions required to manage sessions.

The rest of the modules are specfic parts of libspotify for accessing information about artists, albums, tracks, and playlists. Separate modules are available to handle searches and images.

This initial chapter of libspotify will focus on the general design of the library, and things to take into consideration once you start working with it.

For most of the functionality, there are examples available in .

Issues and Restrictions

A few restrictions apply to the libspotify library. These may be changed (or fixed) in future versions of the library.

Only one process can access the cache and settings directory. It is your responsibility to make sure instances of your application, or any other application and your application does not attempt to use the same cache. You can do this using a clever naming schema, or using a lock-file.
Even though sp_session_init() creates a new object, there are still some global variables behind the scenes that will stop you from creating multiple sessions within a single process.
General Design

In this section, you will find the overall philosophy of the library with regard to memory management and error handling.

Error Handling

All functions that have some form of useful error state returns an sp_error. The actual result value is returned in an out pointer in these cases. Some functions return pointers where you must check for NULL before using the returned value. Those places should be documented next to each function.

In addition to functions returning an sp_error, some request objects (browse and search objects) have an error accessor. When the object has been loaded, the error code will be set to reflect the success or failure of the request.

A trivial error code to string mapper function exists that works just like strerror(3).

Reference Counting

Reference counting is used for all domain objects in libspotify. Functions including the string create will return an object with a pre-incremented reference count. Thus, each create must have a corresponding release when the value is no longer needed.

Other accessor functions (including sp_link_as_artist et al.), on the other hand, returns a reference borrowed from the object it was retrieved from. Retrieving an sp_album from an sp_link would make the album object survive until the link object is freed, unless its reference count is explicitly incremented.

Threads

The library itself uses multiple threads internally. To allow for synchronization between these threads, you must implement the sp_session_callbacks::notify_main_thread callback. Whenever called (from some internal thread), the application must wake up the main loop so the sp_session_process_events() function can be run.

The API itself is not thread-safe. Thus, you must take care not to call the API functions from more than one of your own threads.

Objects

All objects (tracks, albums, artists, etc) are loaded asynchronously. Therefore the API user must query the object via the _is_loaded() functions to check that the object data has been populated. There is currently no way of finding out when data has been updated for a specific object. Rather, the user need to iterate all objects of interest upon invokation of the metadata_updated() callback.

Also, objects are not populated when created as a result of a sp_link_as_...() method.

Disk Cache Management

Currently the disk cache can only be opened by one process at a time. It is preferrable not to put the cache in a network file system. To avoid clashes, we recommend you to put set the cache location to /var/tmp/username/appname/ and to add some kind of lock. The appname would be a mangled user-agent string.

While you could simply remove the cache when the application exits to avoid the locking issue, your application will be slower as music, playlists and other metadata will have to be loaded from the server on each login. You are strongly encouraged to use a persistent cache.

Settings should be stored in the users home directory, but they should also be kept separate per application. We would recommend ~/.config/appname/libspotify/ for these files on UNIX-like systems or %appdata%\appname\libspotify\ on Windows.

Session Management

Before running any application you will need an application key. An application key allows Spotify to identify your application and should be unique per application. You will find more information about the application keys on our developer website. We have choosen not to distribute the example programs with an application key, as that might cause the key to be misused. We encourage you to get a valid application key, and put it in a file called appkey.c and compile the examples using the included makefile.

In order to ensure all data is correctly synced to disk, we encourage you to actually use sp_session_logout() before terminating your application. Efter logout, you will receive a callback call in which you could display a login box, or terminate.

Images

Images are identified with a const byte* value, returned by various functions in the API (such as sp_album_cover()). The pointers are valid until the object is freed, thus you should keep a reference to the objects until you are no longer using the image ID.

It is also possible to get references to images as URIs (see the sp_link type). This might be favourable if you need to store a reference to an image for later use but want to release the originating object.

Images will always be given to the application compressed using a image compression format. Currently only JPEG encoded images are delivered. See sp_image_format(). The API user should use sp_image_data() to get the encoded data and the application need to do the decoding of the image by itself.

Audio

The audio is delivered through a push-callback called by libspotify when data is available. Your callback may eat all data, or just enough to fill some constant-sized buffer. The callback will be called from a libspotify internal thread, so if you share state between the audio callback and the main thread, be sure to add adequate thread synchronization.

Samples are delivered as integers, see sp_audioformat. One frame consists of the same number of samples as there are channels. I.e. interleaving is on the sample level.

Examples

Included in the distribution are a couple of example files designed to get you started easily.

Licenses

The example code distributed with libspotify uses the MIT license. All documentation, libspotify itself, and the associated C header file are distributed under the libspotify Terms of Use.

Generated on Tue Oct 8 2013 14:22:40. Copyright © 2006–2013 Spotify AB
