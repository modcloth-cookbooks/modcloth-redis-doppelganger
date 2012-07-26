#!/bin/env bash
redis-cli info|grep used_memory: |cut -d ':' -f2