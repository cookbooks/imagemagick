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
 
src_filepath  = "#{Chef::Config['file_cache_path'] || '/tmp'}/ImageMagick.tar.gz"

package dev_pkg

remote_file imagemagick_url do
  source imagemagick_url
  path src_filepath
  backup false
end

bash "compile_nginx_source" do
  cwd ::File.dirname(src_filepath)
  code <<-EOH
    tar -xzvf #{::File.basename(src_filepath)} -C /tmp/imagemagick &&
    cd /tmp/imagemagick &&
    ./configure &&
    make && make install &&
    ldconfig /usr/local/lib
  EOH
end