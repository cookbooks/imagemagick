imagemagick_url = "http://www.imagemagick.org/download/ImageMagick.tar.gz"

dev_pkg = value_for_platform(
  ["redhat", "centos", "fedora"] => { "default" => "ImageMagick-devel" },
  "debian" => { "default" => "libmagickwand-dev" },
  "ubuntu" => {
    "8.04" => "libmagick9-dev",
    "8.10" => "libmagick9-dev",
    "default" => "libmagickwand-dev"
  }
)
 
# src_filepath  = "/tmp/ImageMagick.tar.gz"

package dev_pkg

# remote_file imagemagick_url do
#   source imagemagick_url
#   path src_filepath
# end

bash "compile_nginx_source" do
  user "root"
  cwd "/tmp"
  code <<-EOH
    wget http://www.imagemagick.org/download/ImageMagick.tar.gz
    tar -xzvf ImageMagick.tar.gz
    cd ImageMagick-6.8.4-10
    ./configure
    make
    make install
    ldconfig /usr/local/lib
  EOH
end