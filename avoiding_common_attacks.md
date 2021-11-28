# Contract security measures

## SWC-103 (Floating pragma)

Specific compiler pragma `0.5.0` used in contracts to avoid accidental bug inclusion through outdated or incompatable compiler versions.

## SWC-105 (Improper Access Control)

The software restricts access to a resource from an unauthorized actor for certain functions. For example, `add beneficiary` is protected with the `require` modifier.

## SWC-118 (Incorrect Constructor Name)

The software correctly initializes the will resource, which does not leave the resource in an unexpected state when it is accessed or used.
