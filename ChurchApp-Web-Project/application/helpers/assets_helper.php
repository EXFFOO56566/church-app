<?php
if (!defined('BASEPATH'))
    exit('No direct script access allowed');

if (!function_exists('asset_url')) {
    function asset_url($uri = '', $group = FALSE) {
        $CI = & get_instance();

        if (!$dir = $CI->config->item('assets_path')) {
            $dir = 'assets/'; // change folder name
        }

        if ($group) {
            return $CI->config->base_url($dir . $group . '/' . $uri);
        } else {
            return $CI->config->base_url($dir . $uri);
        }
    }
}
