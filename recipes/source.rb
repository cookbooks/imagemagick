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
  backup false

  not_if {File.exists?(src_filepath)}
end

node.run_state['imagemagick_force_recompile'] = false

bash "compile_imagemagick_source" do
  cwd ::File.dirname(src_filepath)
  code <<-EOH
    tar -xzvf #{::File.basename(src_filepath)}
    cd ImageMagick-#{node['imagemagick']['version']}
    ./configure
    make
    make install
    ldconfig /usr/local/lib
  EOH

  not_if do
    identify = Mixlib::ShellOut.new("identify -version")
    identify.run_command rescue return true
    identify.stdout.split("\n") == ["Version: ImageMagick 6.8.4-10 2013-04-18 Q16 http://www.imagemagick.org", "Copyright: Copyright (C) 1999-2013 ImageMagick Studio LLC", "Features: DPC OpenMP", "Delegates: bzlib djvu fontconfig freetype jng jp2 jpeg lcms lqr openexr pango png ps tiff x xml zlib"]
  end

end