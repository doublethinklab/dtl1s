class Post < ApplicationRecord
    belongs_to :node
    has_many :links

    def self.search(search)
        if search
          where(link: search)
        else
          limit(50)
        end
    end

    def self.import(file)
        require 'csv'
        CSV.foreach(file.path, headers: true) do |row|
            row_hash = row.to_hash
            write_posts(
                row_hash, 
                row_hash['Facebook Id'], 
                'crowdtangle_csv', 
                row_hash['URL'], 
                row_hash['Message'], 
                row_hash['Link'], 
                row_hash['User Name'],
                row_hash['Created'],
                row_hash['Created'],
                row_hash['Description'],
                row_hash['Overperforming Score']
            )
        end
    end

    def self.api_import
        require 'net/https'
        token = ENV['CT_TOCKEN']
        list_id = '1290974'

        uri = URI("https://api.crowdtangle.com/posts?token=#{token}&listIds=#{list_id}&startDate=#{Date.today.strftime("%Y-%m-%d")}&sortBy=date&count=100")
        request = Net::HTTP.get_response(uri)
        puts rows_hash = JSON.parse(request.body)['result']['posts'] if request.is_a?(Net::HTTPSuccess)
        rows_hash.each do |row_hash|
            write_posts(
                row_hash, 
                row_hash['account']['platformId'],
                'crowdtangle_api', 
                row_hash['postUrl'], 
                row_hash['message'] || row_hash['title'], 
                row_hash['link'], 
                row_hash['account']['handle'],
                row_hash['date'],
                row_hash['updated'],
                row_hash['title'] && row_hash['description'] ? (row_hash['title'] + "__" + row_hash['description']) : '',
                row_hash['score']
            )
        end
    end

    def self.write_posts(
        row_hash, 
        platform_id, 
        source, 
        url, 
        message, 
        link, 
        user_name, 
        date, 
        updated, 
        link_description,
        score
    )
        node = Node.find_or_create_by(
            name: platform_id, 
            source: source, 
            url: "https://www.facebook.com/#{platform_id}",
            archive: {
                user_name: user_name,
            }
        )

        post = node.posts.create!(
            archive: row_hash, 
            url: url, 
            title: message, 
            link: link, 
            date: date,
            updated: updated,
            score: score
        )

        if row_hash['expandedLinks']
            row_hash['expandedLinks'].each do |e|
                post.links.create!(
                    url: e['expanded'], 
                    description: link_description,
                ) 
            end
        else
            post.links.create!(
                url: link, 
                description: link_description,
            ) 
        end

    end

end
