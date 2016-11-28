include "console.iol"
include "time.iol"
include "runtime.iol"
include "file.iol"
include "string_utils.iol"

constants {
  BOT_TOKEN = "REPLACE_WITH_BOT_TOKEN",
  API_URL = "socket://api.telegram.org:443/REPLACE_WITH_BOT_TOKEN/"
}

execution{ concurrent }

outputPort Telegram {
  Location: API_URL
  Protocol: https { 
    // .debug = true;
    // .debug.showContent = true;
    .osc.sendMessage.method = "post";
    .format -> format
  }
  RequestResponse: getM, getUpdates, sendMessage
}

inputPort Local {
  Location: "local"
  OneWay: getUpdate, handleMessage
}

outputPort Local {
  OneWay: getUpdate, handleMessage
}

init
{
  getLocalLocation@Runtime()( Local.location );
  getUpdate@Local()
}

define update_offset { writeFile@File( { .filename = "offset", .content = offset } )() }
define load_offset { readFile@File( { .filename = "offset" } )( offset ) }

main
{
  [ getUpdate() ]{
    format = "json";
    load_offset;
    println@Console( "getting the update" )();
    // getUpdates@Telegram( { .offset = offset } )( s );
    scope( scopeName )
    {
      install( default => nullProcess );
      getUpdates@Telegram( { .offset = offset, .timeout = "30000" } )( s )
    };
    // if( #s.result > 0 ) {
      println@Console( "######################## UPDATE ######################## " )();
      valueToPrettyString@StringUtils( s )( t );
      println@Console( t )();
      println@Console( "######################## UPDATE ######################## " )()
    // }
    ;
    for ( result in s.result ) {
      println@Console( result.message.text )()
    };
    if( #s.result > 0 ) {  offset++; update_offset };
    setNextTimeout@Time( 1000 { .operation = "getUpdate" }  )
  }
}