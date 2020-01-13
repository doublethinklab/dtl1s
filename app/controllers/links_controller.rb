class LinksController < ApplicationController
    def index
        @links = Link.all
        @links = if params[:url].present? || params[:description].present?
            @links.search(params[:url]).search_context(params[:description])
        else 
            Link.none
        end
        @links = @links.includes(:post).order(created_at: :desc) 

        respond_to do |format|
            format.html # index.html.erb
            format.json { render json: @links }
        end
    end
end

# TODO 
# @link_tops = @links.top_group
# @link_domains = @links.top_domain

# @nodes = Node.pluck(:archive)

# @old_nodes = []
# @new_nodes = []

# @nodes.each do |n|
#     @old_nodes << n['name']
#     @old_nodes << n['user_name']
# end
# @link_tops_nodes = @link_tops.map{|a| a[0].include?('facebook') ? a[0] : nil }.compact.map{|x| x.split('/')[3]}.map{|x| (x.length < 40) ? x : nil}.uniq
# @new_nodes = @link_tops_nodes - @old_nodes - ['groups','act', 'notes', 'hashtag']
