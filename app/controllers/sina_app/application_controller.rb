class SinaApp::ApplicationController < ApplicationController
  def assign_project
    @project = Project.find 8
  end
end
