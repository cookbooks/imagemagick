imagemagick_url = node['imagemagick']['source']['url']

dev_pkg = value_for_platform(
  ["redhat", "centos", "fedora"] => { "default" => "ImageMagick-devel" },
  "debian" => { "default" => "libmagickwand-dev" },
  "ubuntu" => {
    "8.04" => "libmagick9-dev",
    "8.10" => "libmagick9-dev",
    "default" => "libmagickwand-dev"
  }
)

src_filepath  = "#{Chef::Config['file_cache_path'] || '/tmp'}/ImageMagick-#{node['imagemagick']['version']}.tar.gz"

package dev_pkg

remote_file imagemagick_url do
  source imagemagick_url
  checksum node['imagemagick']['source']['checksum']
  path src_filepath
end

bash "compile_imagemagick_source" do
  cwd ::File.dirname(src_filepath)
  user 'root'
  code <<-EOH
    tar -xzvf #{::File.basename(src_filepath)}
    cd ImageMagick-#{node['imagemagick']['version']}
    ./configure
    make
    make install
    ldconfig /usr/local/lib
    cd #{File.dirname(src_filepath)}
    rm -rf ImageMagick-#{node['imagemagick']['version']}
  EOH

  not_if { File.exists?("/usr/local/bin/identify") }

end