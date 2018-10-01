<?php if (!defined('THINK_PATH')) exit();?><!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Title</title>
</head>
<body>
<form action="<?php echo U('Home/User/register/');?>"  method="post">
    <input type="text" name="email" value="">
    <input type="password"  name="password" value="">
    <input type="submit" value="Login">
</form>
</body>
</html>