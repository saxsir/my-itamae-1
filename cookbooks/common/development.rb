%w{
  apache2-utils
  apt-file
  jq
  ntp
  screen
  sqlite3
  sysstat
  tmux
  tree
  valgrind
  vim
  whois
  zip
  zsh
}.each do |pkg|
  package pkg do
    action :install
  end
end
