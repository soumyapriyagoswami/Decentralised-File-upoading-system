// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

contract Upload {
    struct Access {
        address user;
        bool access;
    }
    mapping(address => string[]) value;
    mapping(address => mapping(address => bool)) ownership;
    mapping(address => Access[]) accessList;
    mapping(address => mapping(address => bool)) previousData;

    function Add(address _user, string memory url) external {
        value[_user].push(url);
    }

    function allow(address user) external {
        if (!ownership[msg.sender][user]) {
            accessList[msg.sender].push(Access(user, true));
            previousData[msg.sender][user] = true;
        } else {
            for (uint256 i = 0; i < accessList[msg.sender].length; i++) {
                if (accessList[msg.sender][i].user == user) {
                    accessList[msg.sender][i].access = true;
                }
            }
        }
        ownership[msg.sender][user] = true;
    }

    function disallow(address user) public {
        ownership[msg.sender][user] = false;
        for (uint256 i = 0; i < accessList[msg.sender].length; i++) {
            if (accessList[msg.sender][i].user == user) {
                accessList[msg.sender][i].access = false;
            }
        }
    }

    function display(address _user) external view returns (string[] memory) {
        require(
            _user == msg.sender || ownership[_user][msg.sender],
            "You don't have access!"
        );
        return value[_user];
    }

    function shareaccess() public view returns (Access[] memory) {
        return accessList[msg.sender];
    }
}
