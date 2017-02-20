template "/etc/profile.d/perlrc.sh" do
  action :create
  source "perl/templates/perlrc.erb"
  mode "0644"
  variables(version: node[:perl][:version])
end

http_request "/tmp/perl-#{node[:perl][:version]}.tar.gz" do
  url "http://www.cpan.org/src/5.0/perl-#{node[:perl][:version]}.tar.gz"
  not_if "test -e /tmp/perl-#{node[:perl][:version]}.tar.gz"
end

execute "Install Perl #{node[:perl][:version]}" do
  command <<-CMD
    cd /tmp && \
    tar xzf perl-#{node[:perl][:version]}.tar.gz && \
    cd perl-#{node[:perl][:version]} && \
    ./Configure -des -Dprefix=/usr/local/perl-#{node[:perl][:version]} && \
    make && make install
  CMD
  not_if "test -e /usr/local/perl-#{node[:perl][:version]}"
end

execute "Install cpanm" do
  command <<-CMD
    . /etc/profile.d/perlrc.sh
    curl -L https://cpanmin.us | perl - App::cpanminus
  CMD
  not_if "test -e /usr/local/perl-#{node[:perl][:version]}/bin/cpanm"
end

execute "Install Carton" do
  command <<-CMD
    . /etc/profile.d/perlrc.sh
    cpanm Carton
  CMD
  not_if "test -e /usr/local/perl-#{node[:perl][:version]}/bin/carton"
end

execute "Install Perl::Tidy" do
  command <<-CMD
    . /etc/profile.d/perlrc.sh
    cpanm Perl::Tidy
  CMD
  not_if "test -e /usr/local/perl-#{node[:perl][:version]}/bin/perltidy"
end

execute "Install Minilla" do
  command <<-CMD
    . /etc/profile.d/perlrc.sh
    cpanm Minilla
  CMD
  not_if "test -e /usr/local/perl-#{node[:perl][:version]}/bin/minil"
end