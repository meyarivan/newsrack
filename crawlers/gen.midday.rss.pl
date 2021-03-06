#!/usr/bin/perl

$scriptPath = $0;
$scriptDir  = $1 if ($scriptPath =~ m{(.*)/(.*)});
if (!$scriptDir) {
	$scriptDir = ".";
}
require "$scriptDir/crawler.lib.pl";

# -- Process a downloaded page
sub ProcessPage
{
   my ($fileName, $url) = ($_[0], $_[1]);
   ($baseHref) = ($url =~ m{(http://.*?)(\/[^/]*)?$}i);
   $baseHref .= "/";
   print LOG "URL               - $url\n";
   print LOG "FILE              - $fileName\n";
   print LOG "DEFAULT BASE HREF - $baseHref\n";

      # Suck in the entire file into 1 line
   $x=$/;
   undef $/;
   open (FILE, "<$fileName");
   $content = <FILE>;
   close FILE;
   $/=$x;

      # Get the title of the page
   if ($content =~ m{<title>(.*?)</title>}is) {
      $title = $1;
      $title =~ s/\s+/ /g;
      print "TITLE of $url is $title\n";
      $links{$url} = $title;
   }

      # Process base href declaration
   if ($content =~ m{base\s+href=(["|']?)([^'"]*/)[^/]*\1}i) {
      ($baseHref) = $2;
      print LOG "BASE HREF         - $baseHref\n";
      ($siteRoot) = $1.$2 if ($baseHref =~ m{(http://)?([^/]*)}i);
      print LOG "SITE ROOT         - $siteRoot\n";
   }
   else {
      $siteRoot = $defSiteRoot;
   }

      # Check if absolute URLs are okay with this page 
	$rejectAbsoluteUrls = &AbsoluteUrlsOkay($baseHref, $defSiteRoot);

      # Initialize the list of new urls
   my $urlList = ();

      # Match anchors -- across multiple lines, and match all instances
   while ($content =~ m{<a.*?href.*?=.*?(['|"]?).*?([^ '"<>]+)\1.*?>(.+?)</a>}isg) {
      ($urlRef, $link) = ($2, $3);
      print LOG "REF - $urlRef; LINK - $link; "; 
      $msg="";
      $ignore = 0;
         # Check this before the "^http" check because
         # some urls might be absolute even though they
         # have the base href in them
      if ($urlRef =~ /$baseHref/oi) {
         $newUrl = $urlRef;
      }
		elsif ($urlRef =~ /^\#/) {
			$thisUrl = $url;
			$thisUrl =~ s/\#.*//;
         $newUrl  = $thisUrl.$urlRef;
		}
      elsif ($urlRef =~ /^http/i) {
         $newUrl = $urlRef;
         $msg    = "-http-";
         $ignore = 1;
      }
      elsif ($urlRef =~ m{^/}) {
         $newUrl = $siteRoot.$urlRef;
			if ($rejectAbsoluteUrls) {
				$msg    = "-ABSOLUTE-";
				$ignore = 1;
			}
      }
      elsif ($urlRef =~ /^\./) {
         $newUrl = $baseHref;
         $msg    = "-./ SAME -";
         $ignore = 1;
      }
      elsif ($urlRef =~ /^\.\./) {
         $newUrl = $baseHref.$urlRef;
         $msg    = "-..-";
         $ignore = 1;
      }
      elsif ($urlRef =~ /^mailto/i) {
         $newUrl = $urlRef;
         $msg    = "-mailto-";
         $ignore = 1;
      }
      else {
         $newUrl = $baseHref.$urlRef;
      }

      ($newUrl =~ s{://}{###}g); 
      ($newUrl =~ s{//}{/}g); 
      ($newUrl =~ s{###}{://}g); 

			# Strip useless stuff from the url
		$newUrl =~ s{(&Title=[^&?]*).*}{$1};

         # Add or ignore, as appropriate
      if ($ignore) {
         print LOG "IGNORING NEW ($msg) - $newUrl\n"
      }
      elsif (!($newUrl =~ /.*\s*#$/) && !$links{$newUrl}) {
         $link =~ s/\s+/ /g;
         print LOG "ADDING NEW - $newUrl\n";
         $urlList[scalar(@urlList)] = $newUrl; 
         $links{$newUrl} = $link;
      }
   }

   return $urlList;
}

############################### MAIN ################################
## This should be the first thing to do!!
&ChangeWorkingDir();

##
## BEGIN CUSTOM CODE 1: This section needs to be customized for every
## newspaper depending on how their site is structured.
##

$newspaper   = "Mid Day";
$prefix      = "midday";
$date        = `date +"%d%m%y"`;
chop $date;
print "Date is $date\n";
$defSiteRoot = "http://mid-day.com";
$url         = "$defSiteRoot/index.htm";

##
## END CUSTOM CODE 1
##

## Initialize
&Initialize("", $url);

$titleMap = {};
$urlMap = {};

## Process the url list while crawling the site
while (@urlList) {
   $total++;
   $url = shift @urlList;
   $url =~ s/(&artid=.*?)&.*/\1/;    # all crap except for artid is useless in the url

   print "URL is $url\n";

   next if ($urlMap{$url});       # Skip if this URL has already been processed;
   next if (! ($url =~ /http/i)); # Skip if this URL is not valid
	next if (($url =~ /\#/i));		 # Skip if the URL has a # in it

      # Get the new page and process it
   $processed++;
   print     "PROCESSING $url ==> $links{$url}\n";
   print LOG "PROCESSING $url ==> $links{$url}\n";
   $urlMap{$url} = $url;

      ## The next line uses information about New Indian Express' URL structure
   if ($url =~ m{/$date.*}) {

			# For most sites, the next line suffices!
		$title = $links{$url};
		$title =~ s/<.*?>//g;

         # get rid of crud in the title
      $title =~ s/(^\s+|\s+$)//g;

      $title = &ReadTitle($url) if ($title =~ m{^\s*$});

         # Error condition?
      $title = "ERROR: NewsRack could not identify title" if ($title =~ m{^\s*$});

         # filter dupes by title too!
      next if !($title =~ /ERROR:/) && $titleMap{$title};
      $titleMap{$title} = 1;
      $desc = $title;
		&PrintRSSItem();
   }
   elsif ($url =~ m{index.htm}) {
		&CrawlWebPage($url);
   }
}

&FinalizeRSSFeed();
&PrintStatsAndCleanup();
