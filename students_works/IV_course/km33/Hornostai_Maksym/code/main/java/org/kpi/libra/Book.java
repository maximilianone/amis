package org.kpi.libra;

public class Book {
    private String book_name;
    private String book_author;
    private String book_publisher;
    private String book_section;
    private Integer book_quantity;

    public Book(String book_name, String book_author, String book_publisher, String book_section, Integer book_quantity){
        this.book_name=book_name;
        this.book_author=book_author;
        this.book_publisher=book_publisher;
        this.book_section=book_section;
        this.book_quantity=book_quantity;
    }

    public String getBook_name(){return book_name;}
    public String getBook_author(){return book_author;}
    public String getBook_publisher(){return book_publisher;}
    public String getBook_section(){return  book_section;}
    public Integer getBook_quantity(){return  book_quantity;}
}
