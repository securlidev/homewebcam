/* Webcamoid, webcam capture application.
 * Copyright (C) 2016  Gonzalo Exequiel Pedone
 *
 * Webcamoid is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * Webcamoid is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with Webcamoid. If not, see <http://www.gnu.org/licenses/>.
 *
 * Web-Site: http://webcamoid.github.io/
 */

#ifndef MEDIASOURCEFFMPEG_H
#define MEDIASOURCEFFMPEG_H

#include "mediasource.h"

class MediaSourceFFmpegPrivate;

class MediaSourceFFmpeg: public MediaSource
{
    Q_OBJECT

    public:
        MediaSourceFFmpeg(QObject *parent=nullptr);
        ~MediaSourceFFmpeg();

        Q_INVOKABLE QStringList medias() const override;
        Q_INVOKABLE QString media() const override;
        Q_INVOKABLE QList<int> streams() const override;
        Q_INVOKABLE QList<int> listTracks(AkCaps::CapsType type) override;
        Q_INVOKABLE QString streamLanguage(int stream) override;
        Q_INVOKABLE bool loop() const override;
        Q_INVOKABLE bool sync() const override;
        Q_INVOKABLE int defaultStream(AkCaps::CapsType type) override;
        Q_INVOKABLE QString description(const QString &media) const override;
        Q_INVOKABLE AkCaps caps(int stream) override;
        Q_INVOKABLE qint64 durationMSecs() override;
        Q_INVOKABLE qint64 currentTimeMSecs() override;
        Q_INVOKABLE qint64 maxPacketQueueSize() const override;
        Q_INVOKABLE bool showLog() const override;
        Q_INVOKABLE AkElement::ElementState state() const override;

    private:
        MediaSourceFFmpegPrivate *d;

    public slots:
        void seek(qint64 mSecs, MediaSource::SeekPosition position) override;
        void setMedia(const QString &media) override;
        void setStreams(const QList<int> &streams) override;
        void setMaxPacketQueueSize(qint64 maxPacketQueueSize) override;
        void setShowLog(bool showLog) override;
        void setLoop(bool loop) override;
        void setSync(bool sync) override;
        void resetMedia() override;
        void resetStreams() override;
        void resetMaxPacketQueueSize() override;
        void resetShowLog() override;
        void resetLoop() override;
        void resetSync() override;
        bool setState(AkElement::ElementState state) override;

    private slots:
        void doLoop();
        void packetConsumed();
        void log();
        bool initContext();
};

#endif // MEDIASOURCEFFMPEG_H