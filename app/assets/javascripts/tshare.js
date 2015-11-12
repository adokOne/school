TShare = {
		facebook: function(el, ev, img, text) {
			ev.preventDefault();
	        url  = '//www.facebook.com/sharer.php?s=100';
	        url += '&p[url]=' + encodeURIComponent($(el).attr('href'));
	        TShare.popup(url);
	    },
	    
		vkontakte: function(el, ev, img, text) {
			ev.preventDefault();
	        url  = '//vkontakte.ru/share.php?';
	        url += 'url=' + encodeURIComponent( $(el).attr('href') );
	        
	        if( img.length > 0 ){
	        	url += '&image=' + encodeURIComponent(img);
	        }
	        TShare.popup(url);
		},
		
	    odnoklassniki: function(el, ev, img, text) {
	    	ev.preventDefault();
	        url  = 'http://www.odnoklassniki.ru/dk?st.cmd=addShare&st.s=1';
	        url += '&st.comments=' + text;
	        url += '&st._surl='    + encodeURIComponent($(el).attr('href'));
	        TShare.popup(url);
	    },
		    
	    googleplus: function(el, ev, img, text){
	    	ev.preventDefault();
			url  = '//plus.google.com/share?';
			url += 'url=' + encodeURIComponent($(el).attr('href'));
			TShare.popup(url);
	    },
	    
	    twitter: function(el, ev, img, text) {
	    	ev.preventDefault();
	        url  = '//twitter.com/share?';
	        url += 'text='      + text;
	        url += '&url='      + encodeURIComponent($(el).attr('href'));
	        TShare.popup(url);
	    },
	    
	    pinterest: function(el, ev, img, text) {
	    	ev.preventDefault();
	        url  = '//www.pinterest.com/pin/create/button/?';
	        url += 'url='      + encodeURIComponent($(el).attr('href'));
	        url += '&media='      + encodeURIComponent(img);
	        url += '&description=' + text;
	        TShare.popup(url);
	    },
		
	    popup: function(url) {
	    	var iMyWidth =  ( $(window).width() / 2) - 300 + window.screenX;
	    	var iMyHeight = ( $(window).height() / 2) - 225 + window.screenY;
	        var params = "status=no,height=450,width=600,resizable=yes,left=" + iMyWidth  + ",top=" + iMyHeight + ",toolbar=no,menubar=no,location=no,directories=no";
	        var pop_wnd = window.open(url, "Share", params);
	        pop_wnd.focus();
	    }
}