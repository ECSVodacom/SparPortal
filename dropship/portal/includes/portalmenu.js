<!--
var tocTab = new Array();var ir=0;
tocTab[ir++] = new Array ('0', 'Menu', '');
tocTab[ir++] = new Array ('1', 'Distribution Centre', 'https://spar.gatewayec.co.za/portal/track/frmcontent.asp?id=DC');
tocTab[ir++] = new Array ('1.1', 'Reports', 'https://spar.gatewayec.co.za/portal/track/frmcontent.asp?id=DCReport');
tocTab[ir++] = new Array ('1.1.1', 'Statistical Data', 'https://spar.gatewayec.co.za/portal/report/stats/default.asp');
tocTab[ir++] = new Array ('1.1.2', 'Supplier Compliance per Buyer', 'https://spar.gatewayec.co.za/portal/report/supplier/default.asp');
tocTab[ir++] = new Array ('1.1.3', 'Seminars (SR)', '');
tocTab[ir++] = new Array ('1.1.3.1', 'Seminars - Phase 1', 'https://spar.gatewayec.co.za/portal/report/seminar/default.asp?dc=1');
tocTab[ir++] = new Array ('1.1.3.2', 'Seminars - Phase 2', 'https://spar.gatewayec.co.za/portal/report/seminar_phase2/default.asp?dc=1');
tocTab[ir++] = new Array ('1.1.3.3', 'Totals', 'https://spar.gatewayec.co.za/portal/report/seminar_phase2/totals.asp?dc=1');
tocTab[ir++] = new Array ('1.1.4', 'Seminars (NR)', '');
tocTab[ir++] = new Array ('1.1.4.1', 'Seminars - Phase 1', 'https://spar.gatewayec.co.za/portal/report/seminar_phase2/default.asp?dc=2');
tocTab[ir++] = new Array ('1.1.4.2', 'Totals', 'https://spar.gatewayec.co.za/portal/report/seminar_phase2/totals.asp?dc=2');
tocTab[ir++] = new Array ('1.1.5', 'Seminars (KZN)', '');
tocTab[ir++] = new Array ('1.1.5.1', 'Seminars - Phase 1', 'https://spar.gatewayec.co.za/portal/report/seminar_phase2/default.asp?dc=3');
tocTab[ir++] = new Array ('1.1.5.2', 'Totals', 'https://spar.gatewayec.co.za/portal/report/seminar_phase2/totals.asp?dc=3');
tocTab[ir++] = new Array ('1.1.6', 'Seminars (EC)', '');
tocTab[ir++] = new Array ('1.1.6.1', 'Seminars - Phase 1', 'https://spar.gatewayec.co.za/portal/report/seminar_phase2/default.asp?dc=4');
tocTab[ir++] = new Array ('1.1.6.2', 'Totals', 'https://spar.gatewayec.co.za/portal/report/seminar_phase2/totals.asp?dc=4');
tocTab[ir++] = new Array ('1.1.7', 'Seminars (WC)', '');
tocTab[ir++] = new Array ('1.1.7.1', 'Seminars - Phase 1', 'https://spar.gatewayec.co.za/portal/report/seminar_phase2/default.asp?dc=5');
tocTab[ir++] = new Array ('1.1.7.2', 'Totals', 'https://spar.gatewayec.co.za/portal/report/seminar_phase2/totals.asp?dc=5');
tocTab[ir++] = new Array ('1.2', 'Administration', 'https://spar.gatewayec.co.za/portal/track/frmcontent.asp?id=DCAdmin');
tocTab[ir++] = new Array ('1.2.1', 'Buyers', '');
tocTab[ir++] = new Array ('1.2.1.1', 'List Buyers', 'https://spar.gatewayec.co.za/portal/admin/dc/buyer');
tocTab[ir++] = new Array ('1.2.1.2', 'Add new Buyer', 'https://spar.gatewayec.co.za/portal/admin/dc/buyer/item.asp');
tocTab[ir++] = new Array ('1.2.1.3', 'Track a Buyer', 'https://spar.gatewayec.co.za/portal/admin/dc/buyer/search/default.asp');
tocTab[ir++] = new Array ('1.2.2', 'Suppliers', '');
tocTab[ir++] = new Array ('1.2.2.1', 'List Suppliers', 'https://spar.gatewayec.co.za/portal/admin/dc/supplier');
tocTab[ir++] = new Array ('1.2.2.2', 'Add new Supplier', 'https://spar.gatewayec.co.za/portal/admin/dc/supplier/item.asp');
tocTab[ir++] = new Array ('1.2.3', 'Lookup', 'https://spar.gatewayec.co.za/portal/admin/dc/password/');
tocTab[ir++] = new Array ('1.2.4', 'Generate Mail', 'https://spar.gatewayec.co.za/portal/admin/dc/mail/');
tocTab[ir++] = new Array ('1.2.5', 'Order Search', 'https://spar.gatewayec.co.za/portal/OrderSearch/');
tocTab[ir++] = new Array ('2', 'Drop Shipment', 'https://spar.gatewayec.co.za/portal/track/frmcontent.asp?id=DS');
tocTab[ir++] = new Array ('2.1', 'Reports', 'https://spar.gatewayec.co.za/portal/track/frmcontent.asp?id=DSReport');
tocTab[ir++] = new Array ('2.2', 'Administration', 'https://spar.gatewayec.co.za/portal/track/frmcontent.asp?id=DSAdmin');
tocTab[ir++] = new Array ('2.2.1', 'Stores', '');
tocTab[ir++] = new Array ('2.2.1.1', 'List Stores', 'https://spar.gatewayec.co.za/portal/admin/ds/store/');
tocTab[ir++] = new Array ('2.2.1.2', 'Add new Store', 'https://spar.gatewayec.co.za/portal/admin/ds/store/item.asp');
tocTab[ir++] = new Array ('2.2.2', 'Suppliers', '');
tocTab[ir++] = new Array ('2.2.2.1', 'List Suppliers', 'https://spar.gatewayec.co.za/portal/admin/ds/supplier');
tocTab[ir++] = new Array ('2.2.2.2', 'Add new Supplier', 'https://spar.gatewayec.co.za/portal/admin/ds/supplier/item.asp');
tocTab[ir++] = new Array ('2.2.3', 'Search', 'https://spar.gatewayec.co.za/portal/admin/ds/search/default.asp');
tocTab[ir++] = new Array ('2.2.4', 'Lookup', 'https://spar.gatewayec.co.za/portal/admin/ds/password/default.asp');
tocTab[ir++] = new Array ('3', 'Ackermans', 'https://spar.gatewayec.co.za/portal/track/frmcontent.asp?id=AckAdmin');
tocTab[ir++] = new Array ('3.1', 'Suppliers', 'https://spar.gatewayec.co.za/portal/admin/ack/supplier/default.asp');tocTab[ir++] = new Array ('3.1.1', 'List Suppliers', 'https://spar.gatewayec.co.za/portal/admin/ack/supplier/default.asp');tocTab[ir++] = new Array ('3.1.2', 'Add new Supplier', 'https://spar.gatewayec.co.za/portal/admin/ack/supplier/item.asp');tocTab[ir++] = new Array ('3.2', 'Search', 'https://spar.gatewayec.co.za/portal/admin/ack/search/default.asp');tocTab[ir++] = new Array ('3.3', 'Password Lookup', 'https://spar.gatewayec.co.za/portal/admin/ack/password/default.asp');tocTab[ir++] = new Array ('3.4', 'Generate Email', 'https://spar.gatewayec.co.za/portal/admin/ack/mail/default.asp');tocTab[ir++] = new Array ('4', 'System Monitor', 'https://spar.gatewayec.co.za/portal/track/frmcontent.asp?id=Monitor');
tocTab[ir++] = new Array ('4.1', '11 December 2012', 'https://spar.gatewayec.co.za/portal/monitor/default.asp?id=11 December 2012');
tocTab[ir++] = new Array ('4.2', '10 December 2012', 'https://spar.gatewayec.co.za/portal/monitor/default.asp?id=10 December 2012');
tocTab[ir++] = new Array ('4.3', '9 December 2012', 'https://spar.gatewayec.co.za/portal/monitor/default.asp?id=9 December 2012');
tocTab[ir++] = new Array ('4.4', '8 December 2012', 'https://spar.gatewayec.co.za/portal/monitor/default.asp?id=8 December 2012');
tocTab[ir++] = new Array ('4.5', '7 December 2012', 'https://spar.gatewayec.co.za/portal/monitor/default.asp?id=7 December 2012');
tocTab[ir++] = new Array ('4.6', '6 December 2012', 'https://spar.gatewayec.co.za/portal/monitor/default.asp?id=6 December 2012');
tocTab[ir++] = new Array ('4.7', '5 December 2012', 'https://spar.gatewayec.co.za/portal/monitor/default.asp?id=5 December 2012');
tocTab[ir++] = new Array ('5', 'Logout', 'https://spar.gatewayec.co.za/portal/logout/default.asp');
var nCols = 4;
//-->
