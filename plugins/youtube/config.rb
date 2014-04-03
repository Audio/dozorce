
module Youtube

  Config = {
    :routes => {
      :long_url => /youtube\.com.*v=([^&$]{11})(&|#| |$)/,
      :short_url => /youtu\.be\/([^&\?$]{11})(&|#| |$)/
    }
  }

end
