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
            <url>https://www.karlabyrinth.org/books/DieFlotteDerMaare400x.png</url>
        </image>
        <title>Die Flotte der Maare</title>
        <itunes:author>skalabyrinth</itunes:author>
HERE

Dir.glob("#{ARGV.first}/*.mp3").sort.each do |file|
    # Get metadata.
    number = file[/\d+/]
    file2 = file.gsub("//", "/").split("/")[-2..-1].join("/")
    name = file2.split("/").last.split(".").first.split("-")[1..-1].join(" -").gsub(/([A-Z])/, " \\1").strip
    title = "#{number}: #{name}"
    mp3 = "https://www.karlabyrinth.org/books/#{file2}"
    guid = file2
    pubdate = File.mtime(file).rfc2822
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
