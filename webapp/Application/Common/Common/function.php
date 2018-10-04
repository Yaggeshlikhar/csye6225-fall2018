<?php
/**
 * Created by PhpStorm.
 * User: dukun
 * Date: 10/03/2018
 * Time: 16:31
 */
 function  json_style($code,$msg,$subcode,$data =null){
    return array(
        'code' => $code,
        'msg'=>$msg,
        'subcode'=>$subcode,
        'data'=>$data
    );

}