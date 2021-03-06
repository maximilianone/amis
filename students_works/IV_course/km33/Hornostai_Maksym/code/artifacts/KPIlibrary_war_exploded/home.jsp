<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
	<head>
		<title>Bookshelf</title>
		<style>
		body {margin:0;
		background-color:#DCDCDC;}

		ul {
			list-style-type: none;
			margin: 0;
			padding: 0;
			overflow: hidden;
			background-color: #333;
			position: fixed;
			top: 0;
			width: 100%;
		}

		li {
			float: left;
			width: 25%;
		}

		li a {
			display: block;
			color: white;
			text-align: center;
			padding: 14px 20px;
			text-decoration: none;
		}

		li a:hover:not(.active) {
			background-color: #111;
		}

		.active {
			background-color: #2F4F4F;
		}
		.regi {
			float: right;
			background-color: #333;
			display: block;
			text-align: center;
			padding: 10px;
			color: white;
			text-decoration: none;
		}
		a.regi:hover{
			background-color: #111;
		}
		input.regi:hover{
			background-color: #111;
		}
		button.regi:hover{
			background-color: #111;
		}
		.regi > a{
			color: white;
			text-decoration: none;
		}
		.loginDialog {
			position: fixed;
			top: 0;
			right: 0;
			bottom: 0;
			left: 0;
			background: rgba(0,0,0,0.8);
			z-index: 99999;
			opacity:0;
			transition: opacity 400ms ease-in;
			pointer-events: none;
		}
		.loginDialog:target {
			opacity:1;
			pointer-events: auto;
		}

		.loginDialog > div {
			width: 400px;
			position: relative;
			margin: 10% auto;
			padding: 5px 20px 13px 20px;
			border-radius: 10px;
			background: #fff;
		}
		.close {
			background: #606061;
			color: #FFFFFF;
			line-height: 25px;
			position: absolute;
			right: -12px;
			text-align: center;
			top: -10px;
			width: 24px;
			text-decoration: none;
			font-weight: bold;
			border-radius: 12px;
			box-shadow: 1px 1px 3px #000;
		}
		
		.button{
			background-color:  #333;
			color: white;
			font-size: 15px;
			padding: 5px 50px
		}
		
		.button:hover {
			background-color: #111;
		}
		
		.close:hover { background: #111; }
		</style>
	</head>
	<body>
		<ul>
			<li><a class="active" href="home.jsp">Home</a></li>
			<li><a href="books.jsp">Books</a></li>
			<li><a href="contact.jsp">Contact</a></li>
			<li><a href="about.jsp">About</a></li>
		</ul>
		<c:if test="${empty sessionScope.user_login}">

		<div style="float: right;margin-top:50px;padding:0px 10px;">
			<a class="regi" href="#login">Log in</a>
			<a class="regi" href="register.jsp">Register</a>
		</div>
		</c:if>
		<c:if test="${!empty sessionScope.user_login}">
			<form method="post" action="authorization">
			<div style="float: right;margin-top:50px;padding:0px 10px;">
				<input type="hidden" name="command" value="logout">
				<c:if test="${!empty sessionScope.admin_login}">

				</c:if>
				<button class="regi" type="submit" formaction="personalCabinet"><a>${sessionScope.user_login} cabinet</a></button>
			<input type="submit" class="regi" value="Logout"/>
			</div>
			</form>
		</c:if>
		<form method="post" action="authorization">
		<div id="login" class="loginDialog">
			<div>
				<a href="#close" title="Close" class="close">X</a>
				<table style="border:#111; border-radius: 4px;">
				<tr>
				<td height="2px"><h3>Username:</h3></td>
				<td style="width:25%;"><input type="text" pattern="[A-Za-z0-9]{4,}" placeholder="Enter Username" name="uname" required></td>
				</tr>
				<tr>
				<td height="2px"><h3>Password:</h3></td>
				<td><input type="password" pattern="[A-Za-z0-9]{4,}" placeholder="Enter Password" name="psw" required ></td>
				</tr>
				</table>
				<input type="hidden" name="command" value="login">
				<center><button class="button" type="submit">Login</button></center>
			</div>>
		</div>
		</form>
		
		<br><div style="padding:20px;margin-top:30px;">
			<center><h1>Welcome to KPI Library</h1></center>
			<h2>Our history:</h2>
			<div style="background-color:#F5FFFA;">
				<center><img src="lib1.jpg" alt="Mountain View" ></center>
				<p>The Scientific and Technical Library of NTUU "KPI" was founded in 1898. At present it is one of the best libraries of Ukraine and Europe as well and represents the combination of architecture, art and modern technologies.</p>
				<p>The university administration has always encouraged the development and consolidation of the Library. Mr. V. Kirpichov, Mr. A. Plygunov, Mr. G. Denysenko and Mr. M. Zgurovsky at different periods occupied the position of the university rector and contributed a lot to the development of the establishment.</p>
				<p>In commemoration of the 100th anniversary of the Library it was named after Professor Mr. G. Denysenko – the Corresponding Member of the Academy of Sciences of Ukraine, the Hero of Socialist Labor. He used to be a rector of the Institute and it was him who initiated the construction of the new Library facilities.</p>
				<p>The University Library was built on the special project. It is located in the campus main square - Square of Knowledge and along with academic building for students and the Cultural Center makes a basic structure of the University architectural complex and it was built in 1975-1984. The total area of the complex is 14000m.2 The Library with its courtyard are well planned: 15 reading halls with 1500 seats capacity, halls with catalogues, information and bibliographic references, 8 book depositories, 6 reader-rooms with educational, scientific and technical, social and economic literature, fiction and periodicals. The location of departments is convenient and efficient. It takes 15-25 minutes for the automated system to process the readers' outgoing requests from the catalogue halls to the book depositories and it helps to optimally satisfy the readers' needs.</p>
				<p>The walls of the Library halls are decorated with wall-paintings by V. Pasivenko, an artist, the Taras Shevchenko state prize-winner. The general concept of the paintings is "Man and Nature"; the titles of the paintings are as follows: "Man and Fire", "Man and Aqua", "Man and Earth", "Man and Space". The idea of the paintings is the harmony of man with nature. The art exhibitions of Ukrainian artists, university teachers and students often take place at the library premises.</p>
				<p>The Library has a fine conference hall for international, local and the university conferences, student's completions, meetings with writers, men of science and culture, leaders of the government, city and university authorities.</p>
				<p>The Library is frequently attended by the government authorities, delegations from various countries. The Library keeps friendly relationship with foreign countries culture centers and the libraries: The British Council, the United States Information Service and the French Cultural Center are among them. The closest cooperation was established with the German Cultural Center – the Goethe Institute, which was located in the Library building during 1993-2005. At present the Library houses the Ukraine-Japan Cultural Center.</p>
				<p>The Library has more than once received grants from International Renaissance Foundation and Open Society Institute.</p>
				<center><img src="lib2.jpg" alt="Mountain View" ></center>
				<p>During 2000 -2007 the Library organized 9 international seminars "IT for libraries and the educational networks management" were held at the Library. The "TEMPUS-TACIS" international program provided assistance to the seminars. The seminars were attended by the delegates from the polytechnic universities of Aachen and Ilmenau (Germany), Delft (Netherlands) and Vienna (Austria). The international scientific workshop "IT in the modern libraries" was also organized at the library. 300 representatives from the technical educational institutions improved their theoretical knowledge and practical skills. The project manager was Prof. Yu. Yakimenko, deputy rector of NTUU "KPI". In the project end was created the Scientific Centre of information technology managers preparatory.</p>
				<p>The Library has established partnership with the well-known publishing and booksellers agencies, such as "Springer", "Elsevier", "Karger " and "Academic-Press"</p>
				<p>The Library is a full and active member of the Ukrainian Libraries Association, The Association of Regional Libraries "ARBICON" and the partner of The Annual International Conference "Libraries and Information resources in the modern science, culture, education and business" The Library signed the agreement on cooperation with the International Library Information and Analytical Center (ILIAC).</p>
				<p>The Library provides service to 50,000 users, 40,000 from them – students. The library is daily attended by 1,300-1,800 readers. The daily books and materials turnover varies from 4,500 up to 6,000 copies. The users have an open access to electronic copies of materials and to the Library web site. The Library stock is annually supplied with 10,000 names of books that, all in all, make 100,000 copies. The Library houses 3 million copies in Ukrainian, Russian, English, German, French and other languages. At present the Library is the subscriber of about 1000 periodic names. The national and international book exchange with international libraries including ILA is widely used</p>
				<center><img src="lib3.jpg" alt="Mountain View" ></center>
				<p>The dissertations, research works and reports conducted by the University researchers are kept in the Library stock. Valuable and unique is the collection of the instructors' works and articles with their autographs and materials on the University history: books, photo albums and summary reports as well.</p>
				<p>The system of the ramified reference search helps to cope with the huge world of books. The Library has the indexes and catalogues system, electronic catalogue, reference editions and a section of reference and bibliographic work.</p>
				<p>The Library has the local computer network with library integrated package "ALEPH-500" for 218 connections. It enables to use automated processing of literature (collection, cataloguing) and helps to supply users with information at the halls and on-line as well. The library has been developing and improving the electronic catalogue since 1987. Great work is being carried out on the old system index card cataloguing. Data base of periodical editions that receives and keeps the Library also has been created. The university Library is creating as at the cataloging halls so at the others halls. The users have the access to Internet free of charge.</p>
				<p>With the help of INTERNET the Library has the access to the full text versions of more than 7500 titles of electronic format journals and articles of such publishers: Springer-Verlag, Academic Press and EBSCO. The Library has access to the database of many libraries of Ukraine, Russia and other countries.</p>
				<p>The library is creating automating issue and delivery of materials at the Library loon system. The Library offers users traditional books as well as materials in electronic format.</p>
				<p>The Library offers users the full text base of Publishing House Springer electronic journals, dissertations. The Library local computer network has been connected up to Internet. It makes accessible the electronic catalogues of world libraries. Internet-class is opened at the Library. The Information Centre of USA has been allocated funds for this class. The Educational Computer Centre is working at the base of this class, where the Library specialists, users and students of Kiev Specialized School of Culture and Art studies.</p>
			</div>
		</div>

	</body>
	</html>
