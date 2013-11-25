namespace :fetch do
  desc "TODO"
  task contours: :environment do
  end
  
  if false
    #  names = {}; Broadcaster.all.each { |b| name = b.display_name; puts name; names[name] ||= []; names[name] << b.id; puts names[name].inspect }; 0
  
    names.each do |name, ids|
      puts name
      if ids.length == 1
        b = Broadcaster.find(ids.first)
        puts "- #{b.callsign}"
        #b.name = name
        #b.save
      else
        parent = Broadcaster.find_by name: name
        ids.each do |id|
          child = Broadcaster.find(id)
          puts "- #{child.callsign}"
          child.parent_id = parent.id
          child.save
        end
      end
    end
  end
  
  task wikipedia_descriptions: :environment do
    require 'open-uri'
    require 'nokogiri'
    require 'json'
    
    #Broadcaster.where("parent_id is null and notes is null").each do |b|
    Broadcaster.where("parent_id is null and wikipedia is null").each do |b|
      callsign = b.callsign || b.children.sort_by { |b| (b.callsign =~ /[0-9]/) ? 1 : 0 }.first.callsign
      url = "http://en.wikipedia.org/w/api.php?action=parse&page=#{callsign}&format=json&prop=text&section=0"
      begin
        puts callsign
        b.wikipedia = JSON.parse(open(url).read)['parse']['text']['*']
        doc = Nokogiri::HTML.parse(b.wikipedia)
        b.notes = doc.at('p').text
        
        if b.notes =~ /may refer to:/ and doc.at("//li[contains(text(), 'radio')]/a[@href]")[:href] =~ %r{/wiki/(.+)}
          url = "http://en.wikipedia.org/w/api.php?action=parse&page=#{$1}&format=json&prop=text&section=0"
          puts url
          b.wikipedia = JSON.parse(open(url).read)['parse']['text']['*']
          doc = Nokogiri::HTML.parse(b.wikipedia)
          b.notes = doc.at('p').text
        end
        
        puts b.notes
        b.save
      rescue
        puts $!
        next
      end
    end
  end
end

if false
  require 'csv'
  CSV.open('radio.csv','w') do |f|
    Broadcaster.where("parent_id is null").each do |b|
      callsign = b.callsign || b.children.sort_by { |b| (b.callsign =~ /[0-9]/) ? 1 : 0 }.first.callsign
      formats = []
      formats << 'classical' if b.notes =~ /classical/i
      formats << 'jazz' if b.notes =~ /jazz/i
      formats << 'aaa' if b.notes =~ /adult album alternative/i
      url = "http://en.wikipedia.org/wiki/#{callsign}"
      puts line = [b.id, b.display_name, callsign, formats.join(','), url, b.notes]
      f << line
    end
  end

  f = CSV.open('radio2.csv','w')
  %w{984 1275 813 538 539 542 2222 964 2191 2283 2299 890 1173 2403 583 2391 577 590 2404 1259 579 2337 705 535 2235 1154 2192 554 2233 2407 867 2325 1146 721 939 2326 2234 2361 1374 2406 2286 1384 2338 1340 2236 1061 1123 2396 767 2296 2385 540 893 752 2402 832 1386 2186 762 1282 1307 1024 1408 2409 605 2287 2238 2239 876 2184 1277 2389 2178 1023 2335 906 1171 2241 2322 2237 722 1360 2255 697 2280 1064 2320 708 2382 677 2333 2371 2216 2343 686 932 933 1240 2344 2345 692 552 999 841 2393 691 2323 913 2405 1002 2244 1118 775 1334 2245 2314 680 1119 2246 736 2247 777 2248 2249 2229 1037 1115 2250 2408 2202 907 902 988 2252 711 2332 2193 2253 2294 2232 2256 1153 2257 698 2258 2199 2213 807 2328 795 2259 962 2293 1036 2195 557 1281 755 2179 551 587 355 2260 2261 2263 1135 601 2395 356 754 547 2225 2190 358 2394 639 2175 566 2316 1395 1279 2315 2208 1336 2350 2264 784 2265 1298 1296 2352 2351 2266 2267 780 2353 2354 1391 2220 2231 968 2268 856 2355 2318 2356 2230 716 2205 2200 874 2251 973 2269 1028 1351 1117 2270 2388 2358 2279 778 786 2390 2360 2329 2271 2209 781 976 971 2189 2176 2181 2397 2272 363 2210 2362 2273 1098 561 2363 1233 2243 2364 2334 2196 1299 2262 570 2275 2274 2198 1221 1148 842 788 1352 2276 2367 1042 2368 2278 2378 2340 927 2369 1242 2336 2224 2242 961 2206 2194 2370 749 2282 629 630 2372 2373 881 2207 1128 1398 2185 2284 1249 2281 1262 1284 2285 843 2398 600 357 1361 2346 597 598 2288 2289 1060 1100 571 1304 2291 565 2214 1305 2221 2292 1289 2341 628 882 1000 1129 2399 2374 2321 2212 704 2317 578 2295 2377 1167 894 2380 688 2327 2400 2201 2203 2379 2319 2342 2381 2324 844 2297 2330 2223 2313 712 1241 2298 1092 866 2331 727 2227 2410 545 572 640 2226 2228 709 2301 2384 845 864 2204 2339 2303 2383 621 1090 1260 2300 713 2366 2302 1287 2401 1359 2211 2304 2387 1273 2277 2215 1346 2197 774 2307 2305 2392 1344 891 2349 683 2306 2308 2309 2310 901 2290 2311 2347 2240 878 2386 2357 825 886 1134 2376 2359 701 2217 776 1051 2365 2218 1354 2312 1076 1358 2375 1403 2254 684 858 2348 1124 2183 2219}.each do |id|
    b = Broadcaster.find id
    puts b.name
    url = Nokogiri::HTML.parse(b.wikipedia).at("th[text()='Website']").next_sibling.next_sibling.at('a')[:href] rescue nil
    row = [b.children.length, url]
    puts row.inspect
    f << row
  end
  
  open('radio.tsv').each_line do |line|
    name, id, formats, url = line.strip.split "\t"
    puts [name, id, formats, url].inspect
    b = Broadcaster.find id
    b.name = name
    b.url = url
    b.format_list = formats
    b.save
  end
end