%define perl_vendorbin %(perl -MConfig -e 'print $Config{vendorbin}')
%define ppn   IPC-ScoreBoard
%define pln   %(n=%{ppn}; echo ${n//-/::})

Name:         perl-%{ppn}
License:      Artistic License
Group:        Development/Libraries/Perl
Requires:     perl = %{perl_version} perl-File-Map
BuildRequires: perl = %{perl_version} perl-File-Map
Autoreqprov:  on
Summary:      %{pln}
Version:      0.03
Release:      1
Source:       %{ppn}-%{version}.tar.gz
BuildRoot:    %{_tmppath}/%{name}-%{version}-build

%description
The %{pln} perl module provides a kind of interprocess communication
similar to the apache scoreboard.

Authors:
--------
    Torsten Förtsch <torsten.foertsch@gmx.net>

%prep
%setup -n %{ppn}-%{version}
# ---------------------------------------------------------------------------

%build
perl Makefile.PL
make && make test
# ---------------------------------------------------------------------------

%install
[ "$RPM_BUILD_ROOT" != "/" ] && [ -d $RPM_BUILD_ROOT ] && rm -rf $RPM_BUILD_ROOT;
make DESTDIR=$RPM_BUILD_ROOT install_vendor
find $RPM_BUILD_ROOT%{_mandir}/man* -type f -print0 |
  xargs -0i^ %{_gzipbin} -9 ^ || true
%perl_process_packlist

%clean
[ "$RPM_BUILD_ROOT" != "/" ] && [ -d $RPM_BUILD_ROOT ] && rm -rf $RPM_BUILD_ROOT;

%files
%defattr(-, root, root)
%{perl_vendorarch}
%doc %{_mandir}/man3
/var/adm/perl-modules/perl-%{ppn}
%doc MANIFEST
