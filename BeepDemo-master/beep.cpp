
#include "beep.h"


/**
 * @brief Beep::Beep
 * @param parent
 */
Beep::Beep(QObject *parent) :
    QObject(parent)
{
    m_wavePtr = nullptr;
    m_open = false;
    ct = QTime::currentTime ();
    qDebug() << __FUNCTION__ << __LINE__ << ct << "Beep object created";
}

/**
 * @brief Beep::~Beep
 */
Beep::~Beep()
{
    deinit();
    if (m_wavePtr)
        delete(m_wavePtr);
}

/**
 * @brief Beep::init
 * @return
 */
bool Beep::init()
{
    if (isOpen()) {
        qDebug() <<__FUNCTION__<<__LINE__ << "[QML] sound card is already open";
        return true;
    }
    ct = QTime::currentTime ();
    qDebug() << __FUNCTION__ << __LINE__ << ct << "Beep init called";
    // Open audio card we wish to use for playback
    int err;
    snd_pcm_stream_t stream = SND_PCM_STREAM_PLAYBACK;
    int mode = SND_PCM_NONBLOCK;
    // mode =0;
    mode = SND_PCM_ASYNC;
    // The third parameter to snd_pcm_open, by the way, indicates the direction of the stream.
    // The only other option here is SND_PCM_STREAM_CAPTURE, which obviously captures audio instead of playing it.
    // The final parameter to snd_pcm_open is the mode in which to open the device.
    // This can be set to SND_PCM_NONBLOCK if you'd like to initialize the device in non-blocking mode,
    // meaning calls to snd_pcm_writei or snd_pcm_writen will not block until space is available in the buffer,
    // but instead immediately return with error code EAGAIN to indicate the write failed,
    // just like any other system call you might be familiar with.

    if ((err = snd_pcm_open(&m_playbackHandle,
                            &SoundCardPortName[0],
                            stream,
                            mode)) < 0)
    {
        qDebug("[QML] can't open audio %s: %s\n", &SoundCardPortName[0], snd_strerror(err));
        return false;
    }
    else
      qDebug() <<__FUNCTION__<<__LINE__ << "[QML] sound card is open";

    m_open = true;
    return true;
}

/**
 * @brief Beep::init
 * @param frequency
 * @param duration
 * @return
 */
bool Beep::init(const int frequency, const int duration)
{
    qDebug()<< QTime::currentTime() << __FUNCTION__ << __LINE__ << "Beep init called with frequency:"+frequency << "and duration:"<<duration;
    m_frequency = frequency;
    m_duration = duration;
    qDebug() << QTime::currentTime()<< "[QML] beeper frequency "<< frequency << " and duration " << duration <<" set";
    return true;
}

/**
 * @brief Beep::duration
 * @return
 */

int Beep::duration()
{
    return m_duration;
}

/**
 * @brief Beep::frequency
 * @return
 */
int Beep::frequency()
{
    return m_frequency;
}

/**
 * @brief Beep::isSoundCard
 * @return
 */
bool Beep::isSoundCard()
{
    QString test = execute("aplay -l");
    if (test.indexOf("Dummy") >= 0)
        return false;
    else
        return true;

}

/**
 * @brief Beep::setVolume
 * @param volume
 */

void Beep::setVolume(int volume)
{
    if (volume >=0 && volume <= 100)
    {
        m_volume = volume;
        QString output = execute(QString("amixer set PCM ").append(QString::number(volume).append("%")));
        qDebug()<< QTime::currentTime()<<__FUNCTION__<<__LINE__ << "[QML]" << output;
    }
    else
        qDebug() << QTime::currentTime()<< "[QML] amixer error: volume must be set between 0 and 100";
}

/**
 * @brief Beep::volume
 * @return
 */
int Beep::volume()
{
    return m_volume;
}


/**
 * @brief Beep::deinit
 */
void Beep::deinit()
{

    // check if we need to close the sound card
    if (isOpen() && m_wavePtr) {
        snd_pcm_close(m_playbackHandle);
        m_open = false;
        qDebug()<< QTime::currentTime()<<__FUNCTION__<<__LINE__  << "[QML] sound card closed";
    }

}

/**
 * @brief Beep::isOpen
 * @return
 */
bool Beep::isOpen()
{
    return m_open;
}

/**
 * @brief Beep::openwave
 * @param path
 * @return
 */
bool Beep::openwave(const QString &path)
{

    m_waveFile = path;
    return true;
    // No wave data loaded yet
    m_wavePtr = nullptr;
    qDebug() << QTime::currentTime() << __FUNCTION__ << __LINE__ << " Openwave setting Params about to be called";
    if (!loadWaveFile(path.toUtf8().data())) {
        return false;
    }
    else {
        // Open audio card we wish to use for playback
        if (isOpen()) {

            switch (m_waveBits)
            {
                case 8:
                    m_format = SND_PCM_FORMAT_U8;
                    break;

                case 16:
                    m_format = SND_PCM_FORMAT_S16;
                    break;

                case 24:
                    m_format = SND_PCM_FORMAT_S24;
                    break;

                case 32:
                    m_format = SND_PCM_FORMAT_S32;
                    break;
            }

            register int err;
            // Set the audio card's hardware parameters (sample rate, bit resolution, etc)
            if ((err = snd_pcm_set_params(m_playbackHandle,
                                          m_format,
                                          SND_PCM_ACCESS_RW_INTERLEAVED,
                                          m_waveChannels,
                                          m_waveRate,
                                          1,
                                          100000)) < 0)
            {
                qDebug() <<QTime::currentTime()<<"[QML] can't set sound parameters:" << snd_strerror(err);
                return false;
            }


        }
    }
    qDebug() <<QTime::currentTime()<< __FUNCTION__ << __LINE__ << ct << "wav file loaded:"+path;
    return true;
}

/**
 * @brief Beep::play_error_recover
 * @return
 */

int Beep::play_error_recover(int error_code)
{
    // Recover the stream state from an error or suspend.
    //Returns:
    // 0 when error code was handled successfuly,
    // otherwise a negative error code
    return snd_pcm_recover(m_playbackHandle,        // pcm	PCM handle
                           error_code,              // error number
                           0);                      // silent	do not print error reason
}

int Beep::write_wave()
{
    //Write interleaved frames to a PCM.
    //Returns:
    // a positive number of frames actually written
    // otherwise a negative error code
            return snd_pcm_writei(m_playbackHandle,      //pcm	PCM handle
                                  m_wavePtr,     //buffer	frames containing buffer
                                  m_waveSize);   //size	frames to be written

}

/**
 * @brief Beep::play
 */
void Beep::play()
{
    qDebug() <<QTime::currentTime()<< __FUNCTION__ << __LINE__ << "about to play wave file:" +m_waveFile;
    QString returnCode =  execute("aplay "+m_waveFile);
    qDebug()<<"aplay return code: "<< returnCode;
       return;
    if (m_wavePtr && isOpen())
    {
        snd_pcm_uframes_t	count;
        uint frames;
        int error_code;
        error_code = snd_pcm_prepare(m_playbackHandle);
        if (error_code){
            qDebug() <<QTime::currentTime()<< __FUNCTION__ << __LINE__ << "snd_pcm_prepare returned error code: "<<error_code;
        }
        else {
            qDebug() <<QTime::currentTime()<< __FUNCTION__ << __LINE__ << "snd_pcm_prepare was sucessfull! f: "<<m_frequency << " d: "<<m_duration;
        }
        // Output the wave data
        count = 0;
        error_code = write_wave();

        if (error_code < 0) {  // If an error, try to recover from it
           qDebug() <<QTime::currentTime()<< __FUNCTION__ << __LINE__ << "snd_pcm_writei returned error code: "<<error_code;

           if (play_error_recover(error_code) < 0)
               qDebug("[QML] error playing wave: %s\n", snd_strerror(error_code));

         }
        else {
           frames = error_code;
           qDebug() <<QTime::currentTime()<< __FUNCTION__ << __LINE__ << " Frames written: " << frames;
         }

        if (frames == m_waveSize)
            snd_pcm_drain(m_playbackHandle);
    }
    else
        play(m_frequency, m_duration);

    qDebug() <<QTime::currentTime()<< __FUNCTION__ << __LINE__ << "finished playing wave file";

}

/**
 * @brief Beep::play
 * @param frequency
 * @param duration
 */
void Beep::play(const int frequency, const int duration)
{
    execute(QString("beep -f ").append(QString::number(frequency).append(" -d ").append(QString::number(duration))));
}

/**
 * @brief Beep::execute
 * @param command
 * @return
 */
QString Beep::execute(QString command)
{
    QProcess p(this);
    p.setProcessChannelMode(QProcess::MergedChannels);
    qDebug()<<QTime::currentTime() << "executing " << command << "\n";

    p.start(command);

    QByteArray data;

    while(p.waitForReadyRead())
        data.append(p.readAll());

    return QString::fromLatin1(data.data());
}

/**
 * @brief Beep::compareID
 * @param id
 * @param ptr
 * @return
 */

unsigned char Beep::compareID(const unsigned char *id, unsigned char *ptr)
{
    unsigned char i = 4;

    while (i--)
    {
        if ( *(id)++ != *(ptr)++ ) return(0);
    }
    return(1);
}

/**
 * @brief Beep::loadWaveFile
 * @param fn
 * @return
 */

bool Beep::loadWaveFile(const char *fn)
{
    FILE_head head;
    int inHandle;

    if ((inHandle = open(fn, O_RDONLY)) == -1)
    {
        qDebug()<<QTime::currentTime()<<__FUNCTION__<<__LINE__  << "[QML] could not open wave file:" << fn ;
        return false;
    }
    else
    {
        // Read in IFF File header
        if (read(inHandle, &head, sizeof(FILE_head)) == sizeof(FILE_head))
        {
            // Is it a RIFF and WAVE?
            if (!compareID(&Riff[0], &head.ID[0]) || !compareID(&Wave[0], &head.Type[0]))
            {
                close(inHandle);
                qDebug()<<QTime::currentTime()<<__FUNCTION__<<__LINE__  << "[QML] " << fn << "is not a wave file.";
                return false;
            }

            // Read in next chunk header
            while (read(inHandle, &head, sizeof(CHUNK_head)) == sizeof(CHUNK_head))
            {
                // ============================ Is it a fmt chunk? ===============================
                if (compareID(&Fmt[0], &head.ID[0]))
                {
                    FORMAT	format;

                    // Read in the remainder of chunk
                    if (read(inHandle, &format.wFormatTag, sizeof(FORMAT)) != sizeof(FORMAT)) break;

                    // Can't handle compressed WAVE files
                    if (format.wFormatTag != 1)
                    {
                        close(inHandle);
                        qDebug()<<QTime::currentTime()<<__FUNCTION__<<__LINE__  << "[QML] compressed wave file is not supported";
                        return false;
                    }

                    m_waveBits = (unsigned char)format.wBitsPerSample;
                    m_waveRate = (unsigned short)format.dwSamplesPerSec;
                    m_waveChannels = format.wChannels;
                }

                // ============================ Is it a data chunk? ===============================
                else if (compareID(&Data[0], &head.ID[0]))
                {
                    // Size of wave data is head.Length. Allocate a buffer and read in the wave data
                    if (!(m_wavePtr = (unsigned char *)malloc(head.Length)))
                    {
                        close(inHandle);
                        qDebug()<<QTime::currentTime() <<__FUNCTION__<<__LINE__ << "[QML] wave file won't fit in RAM";
                        return false;
                    }

                    if (read(inHandle, m_wavePtr, head.Length) != head.Length)
                    {
                        close(inHandle);
                        free(m_wavePtr);
                        return false;
                    }

                    // Store size (in frames)
                    m_waveSize = (head.Length * 8) / ((unsigned int)m_waveBits * (unsigned int)m_waveChannels);

                    close(inHandle);
                    break;
                }

                // ============================ Skip this chunk ===============================
                else
                {
                    if (head.Length & 1) ++head.Length;  // If odd, round it up to account for pad byte
                    lseek(inHandle, head.Length, SEEK_CUR);
                }
            }
        }
    }

    qDebug()<<QTime::currentTime()<<"[QML] beeper wave file loaded "<< fn;
    return true;

}


