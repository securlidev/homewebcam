/* Webcamoid, webcam capture application.
 * Copyright (C) 2020  Gonzalo Exequiel Pedone
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

#include <QColor>

#include "aktheme.h"
#include "akpalette.h"

class AkThemeGlobalPrivate: public QObject
{
    Q_OBJECT

    public:
        qreal m_controlScale {1.6};

        explicit AkThemeGlobalPrivate(QObject *parent=nullptr);
        qreal controlScale() const;

    signals:
        void controlScaleChanged(qreal controlScale);

    public slots:
        void setControlScale(qreal controlScale);
};

Q_GLOBAL_STATIC(AkThemeGlobalPrivate, akThemeGlobalPrivate)

class AkThemePrivate
{
    public:
        AkTheme *self;
        AkPalette m_palette;

        explicit AkThemePrivate(AkTheme *self);
};

AkTheme::AkTheme(QObject *parent):
    QObject(parent)
{
    this->d = new AkThemePrivate(this);
    QObject::connect(akThemeGlobalPrivate,
                     &AkThemeGlobalPrivate::controlScaleChanged,
                     this,
                     &AkTheme::controlScaleChanged);
}

AkTheme::~AkTheme()
{
    delete this->d;
}

AkTheme *AkTheme::qmlAttachedProperties(QObject *object)
{
    return new AkTheme(object);
}

AkPalette *AkTheme::palette() const
{
    return &this->d->m_palette;
}

qreal AkTheme::controlScale() const
{
    return akThemeGlobalPrivate->controlScale();
}

QColor AkTheme::contrast(const QColor &color, qreal value) const
{
    if (color.lightnessF() < value)
        return {255, 255, 255};

    return {0, 0, 0};
}

QColor AkTheme::complementary(const QColor &color) const
{
    return {255 - color.red(),
            255 - color.green(),
            255 - color.blue(),
            color.alpha()};
}

QColor AkTheme::constShade(const QColor &color, qreal value, qreal alpha) const
{
    auto lightness = qMin(qMax(0.0, color.lightnessF() + value), 1.0);

    return QColor::fromHslF(color.hslHueF(),
                            color.hslSaturationF(),
                            lightness,
                            alpha);
}

QColor AkTheme::shade(const QColor &color, qreal value, qreal alpha) const
{
    if (color.lightnessF() < 0.5)
        value = -value;

    auto lightness = qMin(qMax(0.0, color.lightnessF() + value), 1.0);

    return QColor::fromHslF(color.hslHueF(),
                            color.hslSaturationF(),
                            lightness,
                            alpha);
}

void AkTheme::setControlScale(qreal controlScale)
{
    akThemeGlobalPrivate->setControlScale(controlScale);
}

void AkTheme::setPalette(const AkPalette *palette)
{
    if (!palette)
        return;

    if (this->d->m_palette == *palette)
        return;

    this->d->m_palette = *palette;
    emit this->paletteChanged(&this->d->m_palette);
}

void AkTheme::resetControlScale()
{
    this->setControlScale(1.6);
}

void AkTheme::resetPalette()
{
    AkPalette palette;
    this->setPalette(&palette);
}

void AkTheme::registerTypes()
{
    qmlRegisterUncreatableType<AkTheme>("Ak", 1, 0, "AkTheme", "AkTheme is an attached property");
}

AkThemePrivate::AkThemePrivate(AkTheme *self):
    self(self)
{

}

AkThemeGlobalPrivate::AkThemeGlobalPrivate(QObject *parent):
    QObject(parent)
{
}

qreal AkThemeGlobalPrivate::controlScale() const
{
    return this->m_controlScale;
}

void AkThemeGlobalPrivate::setControlScale(qreal controlScale)
{
    if (qFuzzyCompare(controlScale, this->m_controlScale))
        return;

    this->m_controlScale = controlScale;
    emit this->controlScaleChanged(controlScale);
}

#include "aktheme.moc"
#include "moc_aktheme.cpp"
