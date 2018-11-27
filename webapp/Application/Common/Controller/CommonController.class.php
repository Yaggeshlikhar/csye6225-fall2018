<?php
/**
 * Created by PhpStorm.
 * User: dukun
 * Date: 10/03/2018
 * Time: 16:34
 */
namespace Common\Controller;
use Think\Controller;
class CommonController extends Controller {

    //jude if login
    public function _initialize()
    {
        $userid=  I('session.userid',null);
        if (!isset($userid)){
            $this->ajaxReturn(json_style(401,"sorry you must login first",10009));
        }
    }

    public function ifRightsubmit($num){
        switch ($num){
            case 1:
                if (!IS_GET){
                    $this->ajaxReturn(json_style(400,"bad request, incorrect submit method",10015));
                }
                break;
            case 2:
                if (!IS_POST){
                    $this->ajaxReturn(json_style(400,"bad request, incorrect submit method",10015));
                }
                break;
            case 3:
                if (!IS_PUT){
                    $this->ajaxReturn(json_style(400,"bad request, incorrect submit method",10015));
                }
                break;
            case 4:
                if (!IS_DELETE){
                    $this->ajaxReturn(json_style(400,"bad request, incorrect submit method",10015));
                }
                break;
        }
    }




}
