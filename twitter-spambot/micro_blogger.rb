require 'jumpstart_auth'

class MicroBlogger
    attr_reader :client
    
    def initialize
        puts "Initializing Microblogger..."
        @client = JumpstartAuth.twitter
    end
    
    def tweet(message)
        if message.length <= 140
            @client.update(message)
        else
            puts "Error: Posts are limited to 140 characters."
        end
    end
    
    def run
        puts "Welcome to the JSL Twitter Client!"
        
        command = ""
        while command != "q"
            printf "Enter command: "
            input = gets.chomp
            parts = input.split(" ")
            command = parts[0]
            
            case command
                when 'q' then puts "Goodbye!"
                when 't' then tweet(parts[1..-1].join(" "))
                when 'dm' then dm(parts[1],parts[2..-1].join(" "))
                when 'spam' then spam_my_friends(parts[1..-1].join(" "))
                when 'elt' then everyones_last_tweet
                else
                    puts "Sorry, I don't know how to #{command}."
            end
        end
    end
            
    def dm(target, message)
        puts "Trying to send #{target} this message:"
        puts message
        
        followers_list
        if @screen_names.include?(target)
            message = "d @#{target} #{message}"
            tweet(message)
        else
            puts "You can only message people who follow you."
        end
    end
                
    def followers_list
        @screen_names = []
        @client.followers.each do |follower|
            @screen_names << @client.user(follower).screen_name
        end
    end
                
    def spam_my_followers(message)
        followers_list
        @screen_names.each do |screen_name|
            dm(screen_name, message)
        end
    end
                    
    def everyones_last_tweet
        friends = @client.friends
        friends.each do |friend|
            puts "@#{friend.screen_name} posted..."
            puts friend.status.text
            puts ""
        end
    end
end

blogger = MicroBlogger.new
blogger.run