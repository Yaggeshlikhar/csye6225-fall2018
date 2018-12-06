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
      $user=  @$_SERVER['PHP_AUTH_USER'];
      $pwd = @$_SERVER['PHP_AUTH_PW'];
      $this->ifvailduser($user,$pwd);
    }
    
        public function ifvailduser($user,$pwd)
    {
        
        if (!isset($user) || !isset($pwd)) {
            $this->ajaxReturn(json_style(400, "please provide auth info", 10001));
        }
        createUser();
        $tb_user = M('user');
        $where['email'] = $user;
        $res = $tb_user->where($where)->find();
        if (isset($res)) {
            if (password_verify($pwd, $res['password'])) {
                $token = $this->getRandomString(20);
                $_SESSION['tokenID'] = $token;
                $_SESSION['userid'] = $res['id'];
               // $this->ajaxReturn(json_style(200, "login success", 10002));
            } else {
                $this->ajaxReturn(json_style(401, "password error,try again", 10003));
            }
        } else {
            $this->ajaxReturn(json_style(401, "the email is not exist", 10004));

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
