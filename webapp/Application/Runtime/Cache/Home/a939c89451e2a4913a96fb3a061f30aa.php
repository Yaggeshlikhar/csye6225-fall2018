<?php if (!defined('THINK_PATH')) exit();?><!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Title</title>
</head>
<body>

<form action="<?php echo U('Home/Action/createTranscation/');?>"  method="post">
    <input type="text" name="description" value="">
    <input type="text" name="merchant" value="">
    <input type="text" name="amount" value="">
    <input type="text" name="category" value="">

    <input type="submit" value="create">
</form>


<form action="<?php echo U('Home/Action/updateTranscation/');?>"  method="put">
    <input type="text" name="transcationid" value="">
    <input type="text" name="description" value="">
    <input type="text" name="merchant" value="">
    <!--<input type="text" name="amount" value="">-->
    <!--<input type="text" name="category" value="">-->

    <input type="submit" value="create">
</form>

</body>
</html>