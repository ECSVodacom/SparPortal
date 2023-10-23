/*
  --- menu items --- 
  note that this structure has changed its format since previous version.
  additional third parameter is added for item scope settings.
  Now this structure is compatible with Tigra Menu GOLD.
  Format description can be found in product documentation.

var MENU_ITEMS = [
	['Menu Compatibility', null, null,
		['Supported Browsers', null, null,
			['Win32 Browsers', null, null, 
				['Internet Explorer 5+'],
				['Netscape 6.0+'],
				['Mozilla 0.9+'],
				['AOL 5+'],
				['Opera 5+']
			],
			['Mac OS Browsers', null, null,
				['Internet Explorer 5+'],
				['Netscape 6.0+'],
				['Mozilla 0.9+'],
				['AOL 5+'],
				['Safari 1.0+']
			],
			['KDE (Linux, FreeBSD)', null, null,
				['Netscape 6.0+'],
				['Mozilla 0.9+']
			]
		],
		['Unsupported Browsers', null, null,
			['Internet Explorer 4.x'],
			['Netscape 4.x']
		],
		['Report test results', 'https://www.softcomplex.com/support.html'],
	],
	['Docs & Info', null, null,
		['Product Page', 'https://www.softcomplex.com/products/tigra_menu/'],
		['Welcome Page', '../'],
		['Documentation', 'https://www.softcomplex.com/products/tigra_menu/docs/'],
		['Forums', 'https://www.softcomplex.com/forum/forumdisplay.php?fid=29'],
		['TM Comparison Table', 'https://www.softcomplex.com/products/tigra_menu/docs/compare_menus.html'],
		['Online Menu Builder', 'https://www.softcomplex.com/products/tigra_menu/builder/'],
	],
	['Product Demos', null, null,
		['Traditional Blue', '../demo1/index.html'],
		['White Steps', '../demo2/index.html'],
		['Inner HTML', '../demo3/index.html'],
		['All Together', '../demo4/index.html'],
		['Frames Targeting', '../demo5/index.html']
	],
	['Contact', null, null,
		['E-mail', 'https://www.softcomplex.com/support.html'],
		['ICQ: 31599891'],
		['Y! ID: softcomplex'],
		['AIM ID: softcomplex']
	],
	
	
	var MENU_ITEMS = [
	['Orders', null, null, null],
	['Invoices', null, null,
		['Generate Blank', '../demo1/index.html']
	],
	['Claims', null, null, null],
	['Credit Notes', null, null, null],
	['Search', null, null, null],
	
];
*/

var MENU_ITEMS = [
	['Orders', 'https://10.34.49.4/spar/dropship/track/dc/frmcontent.asp?action=1&amp;id=12 Aug 2004',null],
	['Invoices', 'https://10.34.49.4/spar/dropship/track/dc/frmcontent.asp?action=2&amp;id=12 Aug 2004', null, 
		['Generate Blank Invoice', 'https://10.34.49.4/spar/dropship/track/dc/invoice/new.asp'],
	],
	['Claims', 'https://10.34.49.4/spar/dropship/track/dc/frmcontent.asp?action=3&amp;id=12 Aug 2004', null],
	['Credit Notes', 'https://10.34.49.4/spar/dropship/track/dc/frmcontent.asp?action=4&amp;id=12 Aug 2004', null, 
		['Generate Blank Credit Note', 'https://10.34.49.4/spar/dropship/track/dc/creditnote/new.asp'],
	],
	['Search', 'https://10.34.49.4/spar/dropship/search/default.asp?id=12 Aug 2004',null],
];

