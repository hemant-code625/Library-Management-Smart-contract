// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Library {
    struct Book {
        uint id;
        string title;
        bool isIssued;
        address issuedTo;
    }

    mapping(uint => Book) public books;
    uint public bookCount;

    event BookAdded(uint id, string title);
    event BookIssued(uint id, address issuedTo);
    event BookReturned(uint id, address returnedBy);

    function addBook(string memory _title) public {
        bookCount++;
        books[bookCount] = Book(bookCount, _title, false, address(0));
        emit BookAdded(bookCount, _title);
    }

    function issueBook(uint _id) public {
        require(_id > 0 && _id <= bookCount, "Invalid Book ID");
        Book storage book = books[_id];
        require(!book.isIssued, "Book already issued");

        book.isIssued = true;
        book.issuedTo = msg.sender;

        emit BookIssued(_id, msg.sender);
    }

    function returnBook(uint _id) public {
        require(_id > 0 && _id <= bookCount, "Invalid Book ID");
        Book storage book = books[_id];
        require(book.isIssued, "Book is not issued");
        require(book.issuedTo == msg.sender, "You didn't issue this book");

        book.isIssued = false;
        book.issuedTo = address(0);

        emit BookReturned(_id, msg.sender);
    }

    function getBook(
        uint _id
    ) public view returns (uint, string memory, bool, address) {
        require(_id > 0 && _id <= bookCount, "Invalid Book ID");
        Book memory book = books[_id];
        return (book.id, book.title, book.isIssued, book.issuedTo);
    }
}
