# 
# Do NOT Edit the Auto-generated Part!
# Generated by: spectacle version 0.27
# 

Name:       harbour-themepack-evolve-plus

# >> macros
# << macros

%{!?qtc_qmake:%define qtc_qmake %qmake}
%{!?qtc_qmake5:%define qtc_qmake5 %qmake5}
%{!?qtc_make:%define qtc_make make}
%{?qtc_builddir:%define _builddir %qtc_builddir}
Summary:    Evolve Plus
Version:    0.2.9
Release:    1
Group:      Qt/Qt
License:    GPLv3
Packager:   fravaccaro <fravaccaro@jollacommunity.it>
URL:        https://github.com/uithemer/harbour-themepack-evolve-plus
Source0:    %{name}-%{version}.tar.bz2
Source100:  harbour-themepack-evolve-plus.yaml
Requires:   sailfishsilica-qt5 >= 0.10.9, sailfish-version >= 2.1.0, harbour-themepacksupport >= 0.8.8-1
BuildRequires:  pkgconfig(sailfishapp) >= 1.0.2
BuildRequires:  pkgconfig(Qt5Core)
BuildRequires:  pkgconfig(Qt5Qml)
BuildRequires:  pkgconfig(Qt5Quick)
BuildRequires:  desktop-file-utils

%description
Evolve Plus theme pack for Sailfish OS.


%prep
%setup -q -n %{name}-%{version}

# >> setup
# << setup

%preun
if [ "$1" = "0" ]; then
    rm -rf /home/nemo/.local/share/%{name}
    rm -rf /home/nemo/.themepack/%{name}
fi

%build
# >> build pre
# << build pre

%qtc_qmake5 

%qtc_make %{?_smp_mflags}

# >> build post
# << build post

%install
rm -rf %{buildroot}
# >> install pre
# << install pre
%qmake5_install

# >> install post
# << install post

desktop-file-install --delete-original       \
  --dir %{buildroot}%{_datadir}/applications             \
   %{buildroot}%{_datadir}/applications/*.desktop

%files
%defattr(-,root,root,-)
%{_bindir}
%{_datadir}/%{name}
%{_datadir}/applications/%{name}.desktop
%{_datadir}/icons/hicolor/*/apps/%{name}.png
# >> files
# << files

%post
chmod +x /usr/share/%{name}/fetchicons.sh
mkdir -p /home/nemo/.themepack/%{name}
if [ -d "/usr/share/%{name}/jolla" ]; then
        mv /usr/share/%{name}/jolla /home/nemo/.themepack/%{name}/
        ln -s /home/nemo/.themepack/%{name}/jolla /usr/share/%{name}/
fi
if [ -d "/usr/share/%{name}/native" ]; then
        mv /usr/share/%{name}/native /home/nemo/.themepack/%{name}/
        ln -s /home/nemo/.themepack/%{name}/native /usr/share/%{name}/
fi
if [ -d "/usr/share/%{name}/apk" ]; then
        mv /usr/share/%{name}/apk /home/nemo/.themepack/%{name}/
        ln -s /home/nemo/.themepack/%{name}/apk /usr/share/%{name}/
fi
if [ -d "/usr/share/%{name}/overlay" ]; then
        mv /usr/share/%{name}/overlay /home/nemo/.themepack/%{name}/
        ln -s /home/nemo/.themepack/%{name}/overlay /usr/share/%{name}/
fi
if [ -d "/usr/share/%{name}/dyncal" ]; then
        mv /usr/share/%{name}/dyncal /home/nemo/.themepack/%{name}
        ln -s /home/nemo/.themepack/%{name}/dyncal /usr/share/%{name}/dyncal
fi
if [ -d "/usr/share/%{name}/dynclock" ]; then
        mv /usr/share/%{name}/dynclock /home/nemo/.themepack/%{name}
        ln -s /home/nemo/.themepack/%{name}/dynclock /usr/share/%{name}/
fi
