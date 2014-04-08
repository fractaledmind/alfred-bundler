<?php

if ( ! isset( $bundler_version ) ) {
  // Define the global bundler versions.
  $bundler_version       = file_get_contents( "$__data/meta/version_major" );
  $bundler_minor_version = file_get_contents( "$__data/meta/version_minor" );
}

function __registerAsset( $bundle , $asset , $version ) {

  global $bundler_version;

  // Exit the function if there is no bundle passed.
  if ( empty( $bundle ) ) return 0;

  $data   = exec( 'echo $HOME' ) . "/Library/Application Support/Alfred 2/Workflow Data/alfred.bundler-$bundler_version";
  $update = FALSE;
  if ( ! file_exists( $data ) ) mkdir( $data );
  if ( ! file_exists( "$data/data" ) ) mkdir( "$data/data" );
  if ( file_exists( "$data/data/registry.json" ) ) {
    $registry = json_decode( file_get_contents( "$data/data/registry.json" ) , TRUE );
  }

  if ( isset( $registry ) && is_array( $registry ) ) {
    if ( isset( $registry[ $asset ] ) ) {
      if ( ! in_array( $version , $registry[ $asset ] ) ) {
        $registry[ $asset ][ $version ] = array();
        $update = TRUE;
      }
      if ( ! in_array( $bundle , $registry[ $asset ][ $version ] ) ) {
        $registry[ $asset ][ $version ][] = $bundle;
        $update = TRUE;
      }
    } else {
      $registry[$asset] = array();
      $registry[ $asset ][ $version ] = array( $bundle );
      $update = TRUE;
    }
  } else {
    $registry = array();
    $registry[ $asset ] = array();
    $registry[ $asset ][ $version ] = array();
    $registry[ $asset ][ $version ][] = $bundle;
    $update = TRUE;
  }

  if ( $update ) file_put_contents( "$data/data/registry.json" , utf8_encode( json_encode( $registry ) ) );

} // End registerAsset()
