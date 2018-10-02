<?php
/**
 * Created by PhpStorm.
 * User: dukun
 * Date: 09/27/2018
 * Time: 18:08
 */

namespace Home\Controller;
use Think\Controller;
class UserController extends Controller {

    //show login page
    public function loginPage(){
     $this->display();
    }

    //login API
    public  function  login(){
     $email = I('post.email',null);
     $password = I('post.password',null);
        if (!isset($email)){

            $this->ajaxReturn($this->json_style(1,"your emial can not empty",10005));

        }
        if (!isset($password)){
            $this->ajaxReturn($this->json_style(1,"your password can not empty",10006));
        }
      $tb_user = M('user');
      $where['email'] = $email;
      $res = $tb_user->where($where)->find();
      if (isset($res)){
       if (password_verify($password,$res['password'])){
           //gerentae token
           $token = $this->getRandomString(20);
           $_SESSION['tokenID'] =$token;
           $this->ajaxReturn($this->json_style(0,"login success",10007,array('tokenID'=>$token)));
       }else{
        $this->ajaxReturn($this->json_style(1,"password error,try again",10008));
       }

      }else{
          $this->ajaxReturn($this->json_style(1,"the email is not exist",10009));

      }
    }

    public function  registerPage(){

     $this->display();
    }

    // register API
    public function  register(){
        $email = I('post.email',null);
        $password = I('post.password',null);
        if (!isset($email)){
          $this->ajaxReturn($this->json_style(1,"your emial can not empty",10001));
        }
        if (!isset($password)){
          $this->ajaxReturn($this->json_style(1,"your password can not empty",10002));
        }
        $data['email'] = $email;

         $tb_user = M('user');
         //first retrive from dB
         $res = $tb_user->where($data)->find();
         if (isset($res)){
         $this->ajaxReturn($this->json_style(1,"your emial has been used ,please change one",10003));
         }else{
         $data['password'] = password_hash($password,PASSWORD_BCRYPT);
         $ans = $tb_user->add($data);

         if ($ans){
             $token = $this->getRandomString(20);
             $_SESSION['tokenID'] =$token;
              $this->ajaxReturn($this->json_style(0,"Success!!",10000,array('tokenID'=>$token)));
         }else{
         $this->ajaxReturn($this->json_style(1,"Sorry, tyr again.",10004));
         }
         }
    }


    private function  json_style($code,$msg,$subcode,$data =null){
        return array(
            'code' => $code,
            'msg'=>$msg,
            'subcode'=>$subcode,
            'data'=>$data
        );

    }

   public  function getRandomString($len, $chars=null)
    {
        if (is_null($chars)) {
            $chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
        }
        mt_srand(10000000*(double)microtime());
        for ($i = 0, $str = '', $lc = strlen($chars)-1; $i < $len; $i++) {
            $str .= $chars[mt_rand(0, $lc)];
        }
        return $str;
    }

}