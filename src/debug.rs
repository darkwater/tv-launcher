use bevy::{camera::primitives::Aabb, color::palettes::css::RED, prelude::*};

#[derive(Default)]
pub struct DebugPlugin;

impl Plugin for DebugPlugin {
    fn build(&self, app: &mut App) {
        app.add_systems(Update, foo);
    }
}

fn foo(aabb: Query<(&Aabb, &Transform)>, mut gizmos: Gizmos) {
    for (aabb, transform) in aabb.iter() {
        gizmos.rect(transform.transform_point(Vec3::ZERO), (aabb.max() - aabb.min()).xy(), RED);
    }
}
