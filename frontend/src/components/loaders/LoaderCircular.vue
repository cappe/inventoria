<template>
  <v-layout
    v-bind="$attrs"
  >
    <v-progress-circular
      :size="size"
      :width="width"
      :color="color"
      :indeterminate="indeterminate"
    />
    <span
      v-if="text"
      :class="`${textClasses} ${textColor}`"
    >
      {{ text }}
    </span>
  </v-layout>
</template>

<script>
  export default {
    props: {
      size: {
        type: Number,
        default: 50,
      },
      width: {
        type: Number,
        default: 3,
      },
      indeterminate: {
        type: Boolean,
        default: true,
      },
      text: {
        type: String,
        default: 'Lataa sisältöä...',
      },
      color: {
        type: String,
        default: 'primary',
      },
      textColor: {
        type: String,
        default: null,
      },
      textClasses: {
        type: String,
        default: 'mt-4',
      },
    },
  };
</script>
