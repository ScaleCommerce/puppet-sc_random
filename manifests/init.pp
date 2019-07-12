# == Class: sc_random
#
# ScaleCommerce Wrapper Module for puppetlabs-apache.
# Manages Supervisord, vhosts, OPCache, ZendGuard Loader, IonCube.
#
# === Variables
#
# [*strings*]
#  array to create random strings
#
# [*numbers*]
#  array to create random numbers
#
# === hiera example
#
# sc_random::strings:
#   my_password:
#     size: 10
#     characters: abc!+
#
# sc_random::numbers:
#   my_number:
#     max: 99
#
# === Authors
#
# Thomas Lohner <tl@scale.sc>
#
# === Copyright
#
# Copyright 2019 ScaleCommerce GmbH.
#
class sc_random (
  Hash $strings = {},
  Hash $numbers = {},
){

  # Merge hashes from multiple layers of hierarchy in hiera
  $hiera_strings = lookup("${module_name}::strings", Optional[Hash], 'deep', undef)
  $final_strings = deep_merge($hiera_strings, $strings)
  $hiera_numbers = lookup("${module_name}::numbers", Optional[Hash], 'deep', undef)
  $final_numbers = deep_merge($hiera_numbers, $numbers)

  # iterate over strings
  $string = $final_strings.reduce({}) |$memo, $x| {

    # set default size
    if $final_strings[$x[0]]['size'] {
      $size = $final_strings[$x[0]]['size']
    } else {
      $size = 16
    }

    # set default characters
    if $final_strings[$x[0]]['size'] {
      $char = $final_strings[$x[0]]['characters']
    } else {
      $char = ''
    }

    # use name as seed
    $seed = $x[0]

    $rand = fqdn_rand_string($size, $char, $seed)

    # merge value from current iteration into hash
    $memo + {$x[0] => $rand}
  }


  # iterate over numbers
  $number = $final_numbers.reduce({}) |$memo, $x| {

    # set default max
    if $final_numbers[$x[0]]['max'] {
      $max = $final_numbers[$x[0]]['max']
    } else {
      $max = 101
    }

    # use name as seed
    $seed = $x[0]

    $rand = fqdn_rand($max, $seed)
    # merge value from current iteration into hash
    $memo + {$x[0] => $rand}
  }

}
