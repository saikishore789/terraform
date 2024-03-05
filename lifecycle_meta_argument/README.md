create_before_destroy

When Terraform determines it needs to destroy an object and recreate it, the normal behavior will create the new object after the existing one is destroyed. Using this attribute will create the new object first and then destroy the old one. This can help reduce downtime. Some objects have restrictions that the use of this setting may cause issues with, preventing objects from existing concurrently. Hence, it is important to understand any resource constraints before using this option.

Prevent_destroy

This lifecycle option prevents Terraform from accidentally removing critical resources. This is useful to avoid downtime when a change would result in the destruction and recreation of resource. This block should be used only when necessary as it will make certain configuration changes impossible.

Ignore_changes

The ignore_changes feature is intended to be used when a resource is created with references to data that may change in the future, but should not affect said resource after its creation. In some rare cases, settings of a remote object are modified by processes outside of Terraform, which Terraform would then attempt to "fix" on the next run. In order to make Terraform share management responsibilities of a single object with a separate process, the ignore_changes meta-argument specifies resource attributes that Terraform should ignore when planning updates to the associated remote object.