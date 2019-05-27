require "open-uri"

# Write RSS header.
puts <<HERE
<?xml version="1.0" encoding="utf-8"?>
<rss xmlns:itunes="http://www.itunes.com/dtds/podcast-1.0.dtd" version="2.0">
    <channel>
        <image>
            <url>https://www.karlabyrinth.org/stories/MyrieZangeDieSymmetrieDasSpiel400x.png</url>
        </image>
        <title>Myrie Zange: Das Spiel</title>
        <itunes:author>Karla Byrinth</itunes:author>
HERE

# Open Myrie main page.
open("https://www.karlabyrinth.org/stories/Myrie.html") do |page|
    # Loop through each MP3 linked there.
    page.read.scan(/MyrieZange-DasSpiel[^"]*.mp3/).each do |file|
        # Get metadata.
        number = file[/\d+/]
        name = file.split("/").last[/[A-Za-z]+/].gsub(/([A-Z])/, " \\1").strip
        title = "#{number}: #{name}"

        mp3 = "https://www.karlabyrinth.org/stories/" + file

        guid = file

        uri = URI(mp3)
        http = Net::HTTP.start(uri.host, :use_ssl => uri.scheme == 'https')
        pubdate = http.head(uri.path)['last-modified']

        # And write an item.
        puts <<HERE
                <item>
                    <title>#{title}</title>
                    <enclosure url="#{mp3}" type="audio/mp3" length="0" />
                    <guid>#{guid}</guid>
                    <pubDate>#{pubdate}</pubDate>
                </item>
HERE
    end
end

# Write RSS footer.
puts <<HERE
    </channel>
</rss>
HERE
