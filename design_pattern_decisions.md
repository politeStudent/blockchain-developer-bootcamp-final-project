# Design patterns used

## Access Control Design Patterns

- `Ownable` control functions which restrict access to certain functions based on roles, are achieved using `Require` (e.g. only the owner can add beneficiaries):

```console
require(wills[_custId].willOwner() == msg.sender, "NOT THE OWNER!");
```

## Inheritance and Interfaces

- `WillFactory` contract inherits the bespoke `Will` contract to enable ownership for one user/will instance.

## Inter-Contract Execution

- The `WillFactory` contract calls the `Will` contract to contruct the individual will instance.
