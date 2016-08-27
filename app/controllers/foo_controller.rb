class FooController < ApplicationController
  def from_action
    render html: "<script>document.write('Hello World')</script>", layout: false
  end

  def from_inline_script
    render layout: false
  end

  def from_application_js
  end
end
