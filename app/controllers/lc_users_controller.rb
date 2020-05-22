class LibraryCloudUsersController < ApplicationController
    before_action :authenticate_user!
	include Harvard::LibraryCloud::Collections

    def create
	  @user = create_library_cloud_user()
    end

end
