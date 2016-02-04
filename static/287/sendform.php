<!DOCTYPE html>
<html lang="ru_RU">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <title>Форма отправлена</title>
    <meta name="description" content=""/>
    <meta name="keywords" content=""/>
    <link href="css/form.css" rel="stylesheet">
    <!--<link rel="shortcut icon" href="../favicon.ico" type="image/x-icon">-->
</head>
    <body>
        <div class="formstyle">
            <?php
                $date=date("d.m.y"); // число.месяц.год 
                $time=date("H:i"); // часы:минуты:секунды 
                $backurl="http://uex.click/287";  // На какую страничку переходит после отправки письма
                //---------------------------------------------------------------------- // 
                //Принимаем постовые данные
                $name=$_POST['name'];
                $telephone=$_POST['telephone'];
                $month=$_POST['month'];
                //Тут указываем на какой ящик посылать письмо
                $to = "teplydom.kiev.ua@gmail.com";
                //Далее идет тема и само сообщение
                $subject = "Заказ звонка";
                $message = "
                Данные отправителя:<br />Имя: ".htmlspecialchars($name)."<br />
                Заказал рекламу: <br />".htmlspecialchars($month)."<br />
                Телефон: ".htmlspecialchars($telephone);
                $headers = "From: uex.click \r\nContent-type: text/html; charset=utf8 \r\n";
                mail ($to, $subject, $message, $headers);
                print "<script language='Javascript'><!-- 
                    function reload() {location = \"$backurl\"}; setTimeout('reload()', 3000); 
                        //--></script> 
                $msg 
                <p>Сообщение отправлено! Подождите, сейчас вы будете перенаправлены на главную страницу...</p>";  
               exit; 
            ?>
        </div>
    </body>
</html>