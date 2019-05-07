
Pod::Spec.new do |spec|

  spec.name         = "TreeCanvasView"
  spec.version      = "1.0.0"
  spec.summary      = "A tree style table view, with parent and children rows."
  spec.description  = "TreeCanvasView is a combinded set of tree data structure and tableview.
  Rows can be added, removed, moved and even collapse or expanded."
  spec.homepage     = "http://finemoment.egloos.com/"
  spec.license      = "MIT"
  spec.author       = { "Ruin09" => "shmruin09@gmail.com" }
  spec.platform     = :ios, "11.0"
  spec.source       = { :git => "https://github.com/shmruin/TreeCanvasView.git", :tag => "1.0.0" }
  spec.source_files = "TreeCanvasView"

end