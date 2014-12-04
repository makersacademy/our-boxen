# Makers Academy specific code goes here

class makersacademy::environment {
  include sublime_text::v2
  include chrome
  
  sublime_text::v2::package { 'Emmet':
    source => 'sergeche/emmet-sublime'
  }

  
}
