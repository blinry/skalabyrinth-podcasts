require "open-uri"

if ARGV.size < 1
    raise "Please provide a directory as an argument. <3"
end

# Write RSS header.
puts <<HERE
<?xml version="1.0" encoding="utf-8"?>
<rss xmlns:itunes="http://www.itunes.com/dtds/podcast-1.0.dtd" version="2.0">
    <channel>
        <image>
            <url>https://www.karlabyrinth.org/stories/MyrieZangeDieSymmetrieDasSpiel400x.png</url>
        </image>
        <title>Myrie Zange: Das Spiel</title>
        <itunes:author>karlabyrinth</itunes:author>
HERE

Dir.glob("#{ARGV.first}/*.mp3").each do |file|
    # Get metadata.
    number = file[/\d+/]
    name = file.split("/").last[/[A-Za-z]+/].gsub(/([A-Z])/, " \\1").strip
    title = "#{number}: #{name}"
    mp3 = "https://www.karlabyrinth.org/stories/#{file}"
    guid = file
    pubdate = File.mtime(file)
    size = File.size(file)

    # And write an item.
    puts <<HERE
            <item>
                <title>#{title}</title>
                <enclosure url="#{mp3}" type="audio/mp3" length="#{size}" />
                <guid>#{guid}</guid>
                <pubDate>#{pubdate}</pubDate>
            </item>
HERE
end

# Write RSS footer.
puts <<HERE
    </channel>
</rss>
HERE
