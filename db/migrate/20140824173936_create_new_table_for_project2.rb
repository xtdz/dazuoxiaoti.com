class CreateNewTableForProject2 < ActiveRecord::Migration
  def change
  	create_table :common_data do |t|
  	  t.integer :skipped_count , :default => 0
  	  t.integer :correct_count , :default => 0
  	  t.integer :incorrect_count , :default => 0
  	  t.integer :participation_count , :default => 0
  	  t.integer :limit , :default => 0
  	  t.integer :coordinator_id
  	  t.integer :sponsor_id
  	  t.datetime :start_time
  	  t.datetime :end_time
  	  t.string :tagline
  	  t.text :description
  	  t.string :name
  	  t.integer :feedback_image_count , :default => 0
  	  t.boolean :hidden , :default => false
  	  t.integer :sharable_id
  	  t.string :sharable_type
  	  t.string :information
  	  t.string :share_question_text
  	  t.string :share_finish_text
  	  t.string :banner_url
      t.has_attached_file :upload_image_main
      t.has_attached_file :upload_image_about
      t.has_attached_file :upload_image_small
      t.has_attached_file :upload_image_banner
      t.has_attached_file :upload_image_share_question1
      t.has_attached_file :upload_image_share_question2
      t.has_attached_file :upload_image_share_finish1
      t.has_attached_file :upload_image_share_finish2
      t.timestamps
  	end
  	create_table :project2s do |t|
  		t.string :coordinator_label
  		t.string :equation_string
  		t.string :tagline2
  		t.string :label_content
      t.timestamps
  	end
  	CommonData.reset_column_information
  	Project2.reset_column_information
  	Project.all.each do |p|
  		data = CommonData.new
  		data.skipped_count = p.skipped_count
  		data.correct_count = p.correct_count
  		data.incorrect_count = p.incorrect_count
  		data.participation_count = p.participation_count
  		data.limit = p.limit
  		data.coordinator_id = p.coordinator_id
  		data.sponsor_id = p.sponsor_id
  		data.start_time = p.start_time
  		data.end_time = p.end_time
  		data.tagline = p.tagline
  		data.description = p.description
  		data.name = p.name
  		data.feedback_image_count = p.feedback_image_count
  		data.hidden = p.hidden
  		if p.project_kind == 1
        data.sharable_id = p.id
  			data.sharable_type = 'Project'
  		else
  			data.sharable_type = 'Project2'
        p2 = Project2.create
        data.sharable_id = p2.id
  		end
  		data.banner_url = p.banner_url
  		data.upload_image_main = p.upload_image_main if p.upload_image_main.exists?
      data.upload_image_about = p.upload_image_about if p.upload_image_about.exists?
      data.upload_image_small = p.upload_image_small if p.upload_image_small.exists?
      data.upload_image_banner = p.upload_image_banner if p.upload_image_banner.exists?
      data.upload_image_share_finish1 = p.upload_image_share_finish1 if p.upload_image_share_finish1.exists?
      data.upload_image_share_finish2 = p.upload_image_share_finish2 if p.upload_image_share_finish2.exists?
      data.upload_image_share_question1 = p.upload_image_share_question1 if p.upload_image_share_question1.exists?
      data.upload_image_share_question2 = p.upload_image_share_question2 if p.upload_image_share_question2.exists?
  		data.sharable = p
  		data.save
  		p.save
  	end
  end
end
